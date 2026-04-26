const std = @import("std");
const assert = std.debug.assert;
const BitSet = std.StaticBitSet(32);

pub fn unset_lsb(x: u32) u32 {
    return x & (x -% 1);
}

test "test unset_lsb" {
    assert(unset_lsb(0b01011000) == 0b01010000);
    assert(unset_lsb(0b00000000) == 0b00000000);
    assert(unset_lsb(0b10000000) == 0b00000000);
    assert(unset_lsb(0b00000001) == 0b00000000);
    assert(unset_lsb(0b00000011) == 0b00000010);
}

pub fn set_lsb(x: u32) u32 {
    return x | (x +% 1);
}

test "test set_lsb" {
    assert(set_lsb(0b01011000) == 0b01011001);
    assert(set_lsb(0b00000000) == 0b00000001);
    assert(set_lsb(0b10000000) == 0b10000001);
    assert(set_lsb(0b00000001) == 0b00000011);
    assert(set_lsb(0b00000011) == 0b00000111);
}

pub fn unset_trailing(x: u32) u32 {
    return x & (x +% 1);
}

test {
    assert(unset_trailing(0b10100111) == 0b10100000);
    assert(unset_trailing(0b00000000) == 0b00000000);
    assert(unset_trailing(0b10000010) == 0b10000010);
    assert(unset_trailing(0b00000001) == 0b00000000);
    assert(unset_trailing(0b00001011) == 0b00001000);
}

pub fn set_trailing(x: u32) u32 {
    return x | (x -% 1);
}

test {
    assert(set_trailing(0b10100110) == 0b10100111);
    assert(set_trailing(0b00000000) == std.math.maxInt(u32));
    assert(set_trailing(0b10000010) == 0b10000011);
    assert(set_trailing(0b00000001) == 0b00000001);
    assert(set_trailing(0b00001000) == 0b00001111);
}

pub fn mask_lsb_zero(x: u32) u32 {
    return ~x & (x +% 1);
}

test {
    assert(mask_lsb_zero(0b10100110) == 0b00000001);
    assert(mask_lsb_zero(0b00000000) == 0b00000001);
    assert(mask_lsb_zero(0b10000010) == 0b00000001);
    assert(mask_lsb_zero(0b00000001) == 0b00000010);
    assert(mask_lsb_zero(0b00001000) == 0b00000001);
    assert(mask_lsb_zero(0b00001111) == 0b00010000);
}

pub fn inv_mask_lsb_one(x: u32) u32 {
    return ~x | (x -% 1);
}

test {
    assert(inv_mask_lsb_one(0b10100110) == std.math.maxInt(u32) - 2);
    assert(inv_mask_lsb_one(0b00000000) == std.math.maxInt(u32));
    var expected = BitSet.initFull();
    expected.unset(1);
    assert(inv_mask_lsb_one(0b10000010) == expected.mask);
}

pub fn trailing_zero_mask(x: u32) u32 {
    return ~x & (x -% 1);
}

test {
    assert(trailing_zero_mask(0b10100110) == 0b00000001);
    assert(trailing_zero_mask(0b00000000) == std.math.maxInt(u32));
    assert(trailing_zero_mask(0b00000011) == 0b00000000);
    assert(trailing_zero_mask(0b01000000) == 0b00111111);
    assert(trailing_zero_mask(0b10100011) == 0b00000000);
}

pub fn inv_trailing_ones_mask(x: u32) u32 {
    return ~x | (x +% 1);
}

test {
    assert(inv_trailing_ones_mask(0b10100110) == std.math.maxInt(u32));
    assert(inv_trailing_ones_mask(0b00000000) == std.math.maxInt(u32));
    var expected = BitSet.initFull();
    expected.unset(0);
    expected.unset(1);
    assert(inv_trailing_ones_mask(0b00000011) == expected.mask);
    expected = BitSet.initFull();
    expected.unset(0);
    expected.unset(1);
    assert(inv_trailing_ones_mask(0b10100011) == expected.mask);
}

pub fn mask_lsb(x: i32) i32 {
    return x & (-x);
}

test {
    var expected = BitSet.initEmpty();
    expected.set(1);
    assert(mask_lsb(0b10100110) == expected.mask);
    assert(mask_lsb(0b00000000) == 0);
    expected = BitSet.initEmpty();
    expected.set(0);
    assert(mask_lsb(0b00000011) == expected.mask);
    expected = BitSet.initEmpty();
    expected.set(0);
    assert(mask_lsb(0b10100011) == expected.mask);
}
