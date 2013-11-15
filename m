Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54856 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab3KORSp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 12:18:45 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VhN2X-0001ml-Cr
	for linux-btrfs@vger.kernel.org; Fri, 15 Nov 2013 18:18:41 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 18:18:41 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 18:18:41 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: [PATCH] Btrfs-progs: allow --init-extent-tree to work when extent
 tree is borked
Date: Fri, 15 Nov 2013 17:18:30 +0000
Message-ID: <l65l0s$lpm$1@ger.gmane.org>
References: <1382724100-5276-1-git-send-email-jbacik@fusionio.com> <l4ed62$8r3$1@ger.gmane.org> <20131025183134.GA4543@localhost.localdomain> <l4hifj$ni1$1@ger.gmane.org> <20131028151148.GB4543@localhost.localdomain> <l5eq5s$m8l$1@ger.gmane.org> <l5rn2s$m3p$1@ger.gmane.org> <l5vq48$2dh$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <l5vq48$2dh$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Another two days and a backtrace shows the hope of progress:

#0  0x000000000041de2f in btrfs_node_key ()
#1  0x000000000041ee79 in btrfs_check_node ()
#2  0x0000000000420211 in check_block ()
#3  0x0000000000420813 in btrfs_search_slot ()
#4  0x0000000000427bb4 in btrfs_read_block_groups ()
#5  0x0000000000423e40 in btrfs_setup_all_roots ()
#6  0x000000000042406d in __open_ctree_fd ()
#7  0x0000000000424126 in open_ctree_fs_info ()
#8  0x000000000041812e in cmd_check ()
#9  0x0000000000404904 in main ()

No other output, 100% CPU, using only a single core, and no apparent
disk activity.

There looks to be a repeating pattern of calls. Is this working though
the same test repeated per btrfs block? Are there any variables that can
be checked with gdb to see how far it has gone so as to guess how long
it might need to run?


Phew?

Hope of interest,

Regards,
Martin




On 13/11/13 12:08, Martin wrote:
> On 11/11/13 22:52, Martin wrote:
>> On 07/11/13 01:25, Martin wrote:
> 
>> OK so Chris Mason and the Gentoo sys-fs/btrfs-progs-9999 came to the
>> rescue to give:
>>
>>
>> # btrfs version
>> Btrfs v0.20-rc1-591-gc652e4e
> 
>> From that, I've tried running again:
>>
>> # btrfsck --repair /dev/sdc
>>
>> giving thus far:
>>
>> parent transid verify failed on 911904604160 wanted 17448 found 17450
>> parent transid verify failed on 911904604160 wanted 17448 found 17450
>> parent transid verify failed on 911904604160 wanted 17448 found 17450
>> parent transid verify failed on 911904604160 wanted 17448 found 17450
>> Ignoring transid failure
>>
>>
>> ... And it is still running a couple of days later.
>>
>> GDB shows:
>>
>> (gdb) bt
>> #0  0x000000000042d576 in read_extent_buffer ()
>> #1  0x000000000041ee79 in btrfs_check_node ()
>> #2  0x0000000000420211 in check_block ()
>> #3  0x0000000000420813 in btrfs_search_slot ()
>> #4  0x0000000000427bb4 in btrfs_read_block_groups ()
>> #5  0x0000000000423e40 in btrfs_setup_all_roots ()
>> #6  0x000000000042406d in __open_ctree_fd ()
>> #7  0x0000000000424126 in open_ctree_fs_info ()
>> #8  0x000000000041812e in cmd_check ()
>> #9  0x0000000000404904 in main ()
> 
> 
> Another two days and:
> 
> (gdb) bt
> #0  0x000000000042373a in read_tree_block ()
> #1  0x0000000000421538 in btrfs_search_slot ()
> #2  0x0000000000427bb4 in btrfs_read_block_groups ()
> #3  0x0000000000423e40 in btrfs_setup_all_roots ()
> #4  0x000000000042406d in __open_ctree_fd ()
> #5  0x0000000000424126 in open_ctree_fs_info ()
> #6  0x000000000041812e in cmd_check ()
> #7  0x0000000000404904 in main ()
> 
> 
>> So... Has it looped or is it busy? There is no activity on /dev/sdc.
> 
> Same "btrfs_read_block_groups" but different stack above that: So
> perhaps something useful is being done?...
> 
> No disk activity noticed.
> 
> 
>> Which comes to a request:
>>
>> Can the options "-v" (for verbose) and "-s" (to continuously show
>> status) be added to btrfsck to give some indication of progress and what
>> is happening? The "-s" should report progress by whatever appropriate
>> real-time counts as done by such as "badblocks -s".



