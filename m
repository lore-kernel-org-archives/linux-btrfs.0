Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48415 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbcEHWSm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 8 May 2016 18:18:42 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by mailout.nyi.internal (Postfix) with ESMTP id 60767208BA
	for <linux-btrfs@vger.kernel.org>; Sun,  8 May 2016 18:18:41 -0400 (EDT)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id 1A1B8C00012
	for <linux-btrfs@vger.kernel.org>; Sun,  8 May 2016 18:18:41 -0400 (EDT)
Received: from vostro.rath.org (vostro [192.168.12.4])
	by ebox.rath.org (Postfix) with ESMTPS id 36E7829ACB7
	for <linux-btrfs@vger.kernel.org>; Sun,  8 May 2016 22:18:40 +0000 (UTC)
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-btrfs@vger.kernel.org
Subject: Input/output error on newly created file
Date: Sun, 08 May 2016 15:18:38 -0700
Message-ID: <8760uoqjlt.fsf@vostro.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I just created an innocent 10 MB on a btrfs file system, yet my attempt
to read it a few seconds later (and ever since), just gives:

$ ls -l in-progress/mysterious-io-error 
-rw-rw-r-- 1 nikratio nikratio 10485760 May  8 14:41 in-progress/mysterious-io-error
$ cat in-progress/mysterious-io-error 
cat: in-progress/mysterious-io-error: Input/output error

I was hoping the kernel might tell me a little more about this, but:

$ dmesg | tail -3
[   48.982851] wlan0: RX AssocResp from 00:1f:33:be:9a:c4 (capab=0x411 status=0 aid=3)
[   48.983757] wlan0: associated
[ 2770.464505] kvm: zapping shadow pages for mmio generation wraparound


How can I find out the reason for the error? Is it a bug in BTRFS,
or somewhere else in the kernel ? Is my hardware broken?

Kernel is Debian's 4.5.0-0.bpo.1-amd64. This is a btrfs file system on a
LVM LV backed by a bcache array with two backing devices and one caching
device.


Best,
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
