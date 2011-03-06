From: "Yo'av Moshe" <bjesus@gmail.com>
Subject: Recovering "parent transid verify failed"
Date: Sun, 6 Mar 2011 12:28:41 +0200
Message-ID: <AANLkTik8z13+5pKThfCSsTeM_08VDCQiKvHD2GEQLqGb@mail.gmail.com>
References: <AANLkTik2t4bG_vwveO=5dovOE=6gDH5FKzjANs7cgRWY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik2t4bG_vwveO=5dovOE=6gDH5FKzjANs7cgRWY@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hey,
I'd start by saying that I know Btrfs is a still experimental, and so
there's no guarantee that one would be able to help me at all... But I
thought I'll try anyway :-)

Few months ago I bought a new laptop and installed ArchLinux on it,
with Btrfs on the root filesystem... I know, it's not the smartest
thing to do...
After a few month I had issues with my hibernations scripts, and one
day I tried to hibernate my computer but it didn't go that well, and,
well, ever since then my Btrfs partition is not accessible.
I opened up the Btrfs FAQ and saw that the fsck tool should be out by
the end of 2010, and thought "oh well, I could wait until then", and
went on and installed Ubuntu with Ext4 on another small partition.

But times goes one and the fsck tool is still in development... I've
tried using the code from GIT and it didn't work, and I'm starting to
wonder (a) if there's any hope at all and (b) what other step am I
able to do to recover my old Btrfs partition.

When trying to mount the Btrfs parition I get this in dmesg:
[105252.779080] device fsid d14e78a602757297-bf762d859b406ca9 devid 1
transid 135714 /dev/sda4
[105252.818697] parent transid verify failed on 216925220864 wanted
135714 found 135713
[105252.819599] parent transid verify failed on 216925220864 wanted
135714 found 135713
[105252.822598] parent transid verify failed on 216925220864 wanted
135714 found 135713
[105252.974588] btrfs: open_ctree failed

This is what I've tried so far:

> btrfs-select-super
>> -s 1 gives me this error:
using SB copy 1, bytenr 67108864
parent transid verify failed on 216925220864 wanted 135714 found 135713
parent transid verify failed on 216925220864 wanted 135714 found 135713
parent transid verify failed on 216925220864 wanted 135714 found 135713
btrfs-select-super: disk-io.c:739: open_ctree_fd: Assertion
`!(!tree_root->node)' failed.
>> -s 2 gives me this error:
using SB copy 2, bytenr 274877906944
No valid Btrfs found on /dev/sda4

> btrfsck
parent transid verify failed on 216925220864 wanted 135714 found 135713
parent transid verify failed on 216925220864 wanted 135714 found 135713
parent transid verify failed on 216925220864 wanted 135714 found 135713
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' failed.

Should I wait for btrfsck to be ready?
Am I not using it correctly now?
Is there anyway to recover this partition or should I just wipe it and
reinstall Btrfs only when I'm supposed to?..

Your help is appreciated.

--
Yo'av Moshe
