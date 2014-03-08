Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shadow.officetone.com ([38.109.180.24]:52177 "EHLO
	shadow.officetone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaCHUfU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Mar 2014 15:35:20 -0500
Received: from maria.officetone.com (shadow.officetone.com [127.0.0.1])
	by shadow.officetone.com (Postfix) with ESMTP id F2D55168242
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Mar 2014 20:35:17 +0000 (UTC)
Message-ID: <531B7F04.30908@travislists.com>
Date: Sat, 08 Mar 2014 20:35:16 +0000
From: Travis Cross <tc@travislists.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send kernel error btrfs_compare_tree
References: <531B6434.1080409@travislists.com>
In-Reply-To: <531B6434.1080409@travislists.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-03-08 18:40, Travis Cross wrote:
> Mar  8 18:13:23 kernel: [ 2041.956270] btrfs: btrfs_compare_tree detected a change in one of the trees while iterating. This is probably a bug.

xaba on IRC helpfully encouraged me to run btrfs check on the device.
I receive a flood of messages:

  Extent back ref already exists for <x> parent 0 root <y>

Then it pauses for awhile, and starts flooding out:

  ref mismatch on [<x> 4096] extent item 1, found 2
  Incorrect global backref count on <x> found 1 wanted 2
  backpointer mismatch on [<x> 4096]

Then it outputs a comparably fewer lines of:

  free space inode generation (0) did not match free space cache generation (<x>)

Finally it outputs:

  checking fs roots

And after some time gets killed by the Linux OOM killer.  The system
has 4G of memory.  The dark irony here is I was trying to btrfs send
the subvolumes off of this disk so I could use it for swap space
because btrfs send operations on other disks were running out of
memory.

The filesystem here was likely created with Linux 3.2 and hasn't seen
much use for awhile, until today I mounted it to try to btrfs send
off those volumes.

xaba noted this could be the result of some 3.2-era kernel bug.  He
recognized the messages I was seeing.  If this is the case, and this
sort of thing is common, it seems we might want to have a way of
detecting this and trying to salvage the situation (particularly as
Debian wheezy -- the last Debian stable release -- is on a 3.2
kernel).

Either way, I'll wait for a consensus here on how to proceed.
