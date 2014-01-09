Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from l2mail1.panix.com ([166.84.1.75]:52071 "EHLO l2mail1.panix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaAIXGp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 18:06:45 -0500
Received: from mailbackend.panix.com (mailbackend.panix.com [166.84.1.89])
	by l2mail1.panix.com (Postfix) with ESMTP id 14BE0390
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jan 2014 17:48:59 -0500 (EST)
Received: from mail-qe0-f44.google.com (mail-qe0-f44.google.com [209.85.128.44])
	by mailbackend.panix.com (Postfix) with ESMTP id 3F2762E109
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jan 2014 17:47:58 -0500 (EST)
Received: by mail-qe0-f44.google.com with SMTP id nd7so3815551qeb.17
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 14:47:57 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 9 Jan 2014 17:47:57 -0500
Message-ID: <CAKCAbMjTHxCQ_rHa2+jV6eEGAGLhYeTWf-9a9y9gp6knzw-xcg@mail.gmail.com>
Subject: Help repairing corrupt btrfs -- btrfsck --repair doesn't change anything
From: Zack Weinberg <zackw@panix.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs partition with what *sounds* like minor damage; btrfsck
--repair prints

| enabling repair mode
| Checking filesystem on /dev/sda
| UUID: ec93d2c2-7937-40f8-aaa6-
c20c9775d93a
| checking extents
| checking free space cache
| cache and super generation don't match, space cache will be invalidated
| checking fs roots
| root 258 inode 4493802 errors 400, nbytes wrong
| root 258 inode 4509858 errors 400, nbytes wrong
| root 258 inode 4510014 errors 400, nbytes wrong
| root 258 inode 4838894 errors 400, nbytes wrong
| root 258 inode 4838895 errors 400, nbytes wrong
| found 41852229430 bytes used err is 1
| total csum bytes: 619630328
| total tree bytes: 3216027648
| total fs tree bytes: 2342981632
| total extent tree bytes: 135536640
| btree space waste bytes: 767795634
| file data blocks allocated: 1744289230848
|  referenced 631766474752
| Btrfs v3.12

The trouble is, these errors do not go away if I run btrfsck --repair
a second time, which implies that the problems have not actually been
corrected.  As the corruption has already caused one kernel oops (see
https://bugzilla.kernel.org/show_bug.cgi?id=68411 ) I am reluctant to
remount the file system until I am sure no corruption remains.  I did
try mounting it (and immediately unmounting it again) and that did
seem to do some sort of additional check ("checking UUID tree") but a
subsequent btrfsck run still prints the same errors.

Any advice on how to fix this so it stays fixed would be appreciated.

zw
