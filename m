From: Craig Johnson <crajohns@gmail.com>
Subject: parent transid verify failures on 2.6.39
Date: Wed, 25 May 2011 14:06:59 -0500
Message-ID: <BANLkTikbunJJTxutLGfs0R_rSfbqWmBf=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After doing an upgrade to 2.6.39 from 2.6.39-rc7, I am unable to mount
my 3 disk btrfs volume.  It was a clean reboot, which makes it all the
more puzzling.  This is what I'm getting:


[68808.339109] device fsid a941511a96bcbfb8-8c123cb07aa6aaa1 devid 2
transid 339584 /dev/sdc1
[68808.340354] device fsid a941511a96bcbfb8-8c123cb07aa6aaa1 devid 1
transid 339584 /dev/sda1
[68808.340774] device fsid a941511a96bcbfb8-8c123cb07aa6aaa1 devid 3
transid 339584 /dev/sdb1

[70106.913668] btrfs: disk space caching is enabled
[70106.968648] parent transid verify failed on 6038227976192 wanted
337418 found 337853
[70106.969031] parent transid verify failed on 6038227976192 wanted
337418 found 337853
[70106.969403] parent transid verify failed on 6038227976192 wanted
337418 found 337853
[70106.969671] parent transid verify failed on 6038227976192 wanted
337418 found 337853
[70106.969691] parent transid verify failed on 6038227976192 wanted
337418 found 337853
[70106.969704] Failed to read block groups: -5
[70107.050658] btrfs: open_ctree failed

I went to run a btrfsck, but found out that I needed to compile with
the tmp branch or I would get an unsupported features message (lzo and
space_cache).  After compiling that, when I run btrfsck, I get this:

parent transid verify failed on 6038227976192 wanted 337418 found 337853
parent transid verify failed on 6038227976192 wanted 337418 found 337853
parent transid verify failed on 6038227976192 wanted 337418 found 337853

And then it stops.  This happens with btrfs-debug-tree, or
btrfs-select-super.  I've tried it on sda1, sdb1, and sdc1 and also
with -s 0, -s 1, and -s 2.  Dmesg shows a segfault:

[71775.589462] btrfsck[14453]: segfault at c4 ip 000000000040e477 sp
00007fffa9eb4d30 error 4 in btrfsck[400000+21000]

For fun, I ran it through gdb and I got this:

Program received signal SIGSEGV, Segmentation fault.
find_first_block_group (root=0x61d1b0, path=0x61ef10, key=0x7fffffffe240)
    at extent-tree.c:3028
3028                    if (slot >= btrfs_header_nritems(leaf)) {



Is there any hope of recovery here?  Not the end of the world if the
volume is lost, but it would be a bit of a pain and I'm at a loss as
to why it happened.  I tried mounting with the new integration-test
branch just for fun, but there's no difference on the mounting.  Any
help that could be provided would be immensely appreciated.  Thanks!

- Craig
