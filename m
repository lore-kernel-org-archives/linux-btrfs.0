Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f196.google.com ([209.85.217.196]:36527 "EHLO
	mail-lb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbbL1BDS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 20:03:18 -0500
Received: by mail-lb0-f196.google.com with SMTP id ti8so9727587lbb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Dec 2015 17:03:17 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 27 Dec 2015 20:03:16 -0500
Message-ID: <CA+X5Wn43URhRg12G48bCPEaZeohA1z_q4Yu5T6CosWfBL9Ui1Q@mail.gmail.com>
Subject: corrupt lead, bad key order & no csum found for inode & csum failed
 ino & input/output error
From: james harvey <jamespharvey20@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Have gotten about 300 (mostly duplicate) BTRFS errors in the last
hours.  No signs of disk problem.  Non-SSD SATA.  Was able to dd the
drive into an image file on another drive without errors.  Smartctl
reports no issues.  It is a single disk though.

Been running btrfs fine since 7/9/15, installing arch linux with linux
4.0.7-2 and btrfs-progs 4.1-1.

Now running linux 4.2.5-1 (installed 10/27, 4.3 isn't in arch core
repo yet) and btrfs-progs 4.3.1-2 (installed 11/24.)

corrupt leaf, bad key order
====================

219 of these lines.  All duplicates.

[ 836.639911] BTRFS critical (device sda2): corrupt leaf, bad key
order: block=241468833792,root=1, slot=292

no csum found / csum failed
=====================

After two of those corrupt lead criticals, have gotten 82 of these
lines.  More of the corrupt leaf criticals between these.  Mostly
duplicates, 5 unique inodes given.  All of these files happen to be
.cache/chromium/Default/Cache/data_* files and
.local/share/baloo/index, which makes sense because that's mostly what
this machine is used for.

[ 836.640132] BTRFS info (device sda2): no csum found for inode
1809716 start 8011776
[ 836.644547] BTRFS warning (device sda2): csum failed ino 1809716 off
8011776 csum 571345089 expected csum 0

Input/output error
=============

Started to run a "btrfs scrub start -B -r /dev/sda2" (didn't see the
messages above on the list recently, so wasn't going to write changes
until I had made a dd disk image on another drive.  Got:

ERROR: scrubbing /dev/sda2 failed for device id 1: ret=-1, errno=5
(Input/output error)
scrub canceled for 535e3d41-989e-4c14-a837-536d79e4ff51
scrub started at Sun Dec 27 18:33:31 2015 and was aborted after 00:18:22
total bytes scrubbed: 156.31GiB with 0 errors

dmesg doesn't show any entries saying something like input/output
error, just the corrupt leaf bad key order, no csum found csum failed
errors.

sda2 is what I'm booted off of, and I'm still running the system
without rebooting, typing this email on it, so the drive didn't stop
being usable after btrfs scrub reported an Input/output error, and
isn't giving more issues besides the above errors.


Obviously looking for comments on all of this, but most interested in
if the corrupt leaf, bad key order message risks a bunch of files or
not.  Familiar with leafs as a computing term, but don't even know
what they are in the context of btrfs.  If it's a single file, how do
I use the corrupt leaf, bad key order block number to see what it
corresponds to, like I did with btrfs inspect-internal with the
inodes?
