Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42237 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab3KYXST (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 18:18:19 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vl5Q2-0003ov-BF
	for linux-btrfs@vger.kernel.org; Tue, 26 Nov 2013 00:18:18 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2013 00:18:18 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2013 00:18:18 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfsck --repair /dev/sdc (Was: [PATCH] Btrfs-progs: allow --init-extent-tree
 to work when extent tree is borked)
Date: Mon, 25 Nov 2013 23:18:08 +0000
Message-ID: <l70lr5$li0$1@ger.gmane.org>
References: <1382724100-5276-1-git-send-email-jbacik@fusionio.com> <l4ed62$8r3$1@ger.gmane.org> <20131025183134.GA4543@localhost.localdomain> <l4hifj$ni1$1@ger.gmane.org> <20131028151148.GB4543@localhost.localdomain> <l5eq5s$m8l$1@ger.gmane.org> <l5rn2s$m3p$1@ger.gmane.org> <l5vq48$2dh$1@ger.gmane.org> <l65l0s$lpm$1@ger.gmane.org> <l6f0pb$m6h$1@ger.gmane.org> <l6hm4u$s02$1@ger.gmane.org> <pan$809d5$4354febd$5ff6e929$a8235336@cox.net> <l6j4c1$a90$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <l6j4c1$a90$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/11/13 20:00, Martin wrote:
> On 20/11/13 17:08, Duncan wrote:
>> Martin posted on Wed, 20 Nov 2013 06:51:20 +0000 as excerpted:
>>
>>> It's now gone back to a pattern from a full week ago:
>>>
>>> (gdb) bt #0  0x000000000042d576 in read_extent_buffer ()
>>> #1  0x000000000041ee79 in btrfs_check_node ()
>>> #2  0x0000000000420211 in check_block ()
>>> #3  0x0000000000420813 in btrfs_search_slot ()
>>> #4  0x0000000000427bb4 in btrfs_read_block_groups ()
>>> #5  0x0000000000423e40 in btrfs_setup_all_roots ()
>>> #6  0x000000000042406d in __open_ctree_fd ()
>>> #7  0x0000000000424126 in open_ctree_fs_info ()
>>> #8  0x000000000041812e in cmd_check ()
>>> #9  0x0000000000404904 in main ()
>>>
>>>
>>> I don't know if that has gone through that pattern during the week but
>>> at a-week-a-time, this is not going to finish in reasonable time.
>>>
>>> How come so very slow?
>>>
>>> Any hints/tips/fixes or abandon the test?
>>
>> You're a patient man. =:^)
> 
> Sort of... I can leave it running in the background until I come to need
> to do something else with that machine. So... A bit of an experiment.


Until... No more... And just as the gdb bt shows something a little
different!

(gdb) bt
#0  0x000000000041ddc4 in btrfs_comp_keys ()
#1  0x00000000004208e9 in btrfs_search_slot ()
#2  0x0000000000427bb4 in btrfs_read_block_groups ()
#3  0x0000000000423e40 in btrfs_setup_all_roots ()
#4  0x000000000042406d in __open_ctree_fd ()
#5  0x0000000000424126 in open_ctree_fs_info ()
#6  0x000000000041812e in cmd_check ()
#7  0x0000000000404904 in main ()


Nearly done or weeks yet more to run?

The poor thing gets killed in the morning for new work.


Regards,
Martin




