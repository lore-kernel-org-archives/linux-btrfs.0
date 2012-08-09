Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:53577 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305Ab2HIHVj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Aug 2012 03:21:39 -0400
Date: Thu, 9 Aug 2012 09:21:29 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dave@jikos.cz>
Subject: Re: [RFC PATCH] Btrfs: fix full backref problem when inserting
 shared block reference
Message-ID: <20120809072129.GC17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <50232A19.2010704@cn.fujitsu.com>
 <20120809064802.GB17430@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120809064802.GB17430@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 09, 2012 at 08:48:02AM +0200, David Sterba wrote:
> and down, no problems so far, and the "wikipedia" test-subvol stresstest
> that caused trouble to one of your patches is also ok. I'll do some more
> testing on other machines and will report problems eventually.

So it won't be so easy :)

The test generated 15+ G of data, ~500 snapshots, then umount and fsck:

lots of

ref mismatch on [9655283712 4096] extent item 1, found 0
Incorrect local backref count on 9655283712 root 5 owner 589776 offset 110592 found 0 wanted 1 back 0x86badf0
backpointer mismatch on [9655283712 4096]
owner ref check failed [9655283712 4096]

and then

checking fs roots
root 2854 inode 233882 errors 2500
root 2880 inode 271639 errors 2200

and it's not finished yet, other types of error may pop up.

david
