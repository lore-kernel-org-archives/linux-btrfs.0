Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52967 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758654Ab3KMMJI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 07:09:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VgZFq-0006jS-HG
	for linux-btrfs@vger.kernel.org; Wed, 13 Nov 2013 13:09:06 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 13:09:06 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 13:09:06 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: [PATCH] Btrfs-progs: allow --init-extent-tree to work when extent
 tree is borked
Date: Wed, 13 Nov 2013 12:08:50 +0000
Message-ID: <l5vq48$2dh$1@ger.gmane.org>
References: <1382724100-5276-1-git-send-email-jbacik@fusionio.com> <l4ed62$8r3$1@ger.gmane.org> <20131025183134.GA4543@localhost.localdomain> <l4hifj$ni1$1@ger.gmane.org> <20131028151148.GB4543@localhost.localdomain> <l5eq5s$m8l$1@ger.gmane.org> <l5rn2s$m3p$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <l5rn2s$m3p$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/11/13 22:52, Martin wrote:
> On 07/11/13 01:25, Martin wrote:

> OK so Chris Mason and the Gentoo sys-fs/btrfs-progs-9999 came to the
> rescue to give:
> 
> 
> # btrfs version
> Btrfs v0.20-rc1-591-gc652e4e

> From that, I've tried running again:
> 
> # btrfsck --repair /dev/sdc
> 
> giving thus far:
> 
> parent transid verify failed on 911904604160 wanted 17448 found 17450
> parent transid verify failed on 911904604160 wanted 17448 found 17450
> parent transid verify failed on 911904604160 wanted 17448 found 17450
> parent transid verify failed on 911904604160 wanted 17448 found 17450
> Ignoring transid failure
> 
> 
> ... And it is still running a couple of days later.
> 
> GDB shows:
> 
> (gdb) bt
> #0  0x000000000042d576 in read_extent_buffer ()
> #1  0x000000000041ee79 in btrfs_check_node ()
> #2  0x0000000000420211 in check_block ()
> #3  0x0000000000420813 in btrfs_search_slot ()
> #4  0x0000000000427bb4 in btrfs_read_block_groups ()
> #5  0x0000000000423e40 in btrfs_setup_all_roots ()
> #6  0x000000000042406d in __open_ctree_fd ()
> #7  0x0000000000424126 in open_ctree_fs_info ()
> #8  0x000000000041812e in cmd_check ()
> #9  0x0000000000404904 in main ()


Another two days and:

(gdb) bt
#0  0x000000000042373a in read_tree_block ()
#1  0x0000000000421538 in btrfs_search_slot ()
#2  0x0000000000427bb4 in btrfs_read_block_groups ()
#3  0x0000000000423e40 in btrfs_setup_all_roots ()
#4  0x000000000042406d in __open_ctree_fd ()
#5  0x0000000000424126 in open_ctree_fs_info ()
#6  0x000000000041812e in cmd_check ()
#7  0x0000000000404904 in main ()


> So... Has it looped or is it busy? There is no activity on /dev/sdc.

Same "btrfs_read_block_groups" but different stack above that: So
perhaps something useful is being done?...

No disk activity noticed.


> Which comes to a request:
> 
> Can the options "-v" (for verbose) and "-s" (to continuously show
> status) be added to btrfsck to give some indication of progress and what
> is happening? The "-s" should report progress by whatever appropriate
> real-time counts as done by such as "badblocks -s".


OK... So I'll leave running for a little while longer before trying a mount.

Some sort of progress indicator would be rather useful... Is this going
to run for a few hours more or might this need to run for weeks to
complete? Any clues to look for?

(All on a 2TByte single disk btrfs, 4k defaults)

Hope of interest.

Regards,
Martin


