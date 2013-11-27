Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33064 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab3K0GaB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Nov 2013 01:30:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VlYdL-00015I-Ja
	for linux-btrfs@vger.kernel.org; Wed, 27 Nov 2013 07:29:59 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 07:29:59 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 07:29:59 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfsck --repair /dev/sdc (Was: [PATCH] Btrfs-progs: allow --init-extent-tree
 to work when extent tree is borked)
Date: Wed, 27 Nov 2013 06:29:49 +0000
Message-ID: <l743gi$ih4$1@ger.gmane.org>
References: <1382724100-5276-1-git-send-email-jbacik@fusionio.com> <l4ed62$8r3$1@ger.gmane.org> <20131025183134.GA4543@localhost.localdomain> <l4hifj$ni1$1@ger.gmane.org> <20131028151148.GB4543@localhost.localdomain> <l5eq5s$m8l$1@ger.gmane.org> <l5rn2s$m3p$1@ger.gmane.org> <l5vq48$2dh$1@ger.gmane.org> <l65l0s$lpm$1@ger.gmane.org> <l6f0pb$m6h$1@ger.gmane.org> <l6hm4u$s02$1@ger.gmane.org> <pan$809d5$4354febd$5ff6e929$a8235336@cox.net> <l6j4c1$a90$1@ger.gmane.org> <l70lr5$li0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <l70lr5$li0$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>>> I don't know if that has gone through that pattern during the week but
>>>> at a-week-a-time, this is not going to finish in reasonable time.
>>>>
>>>> How come so very slow?
>>>>
>>>> Any hints/tips/fixes or abandon the test?
>>>
>>> You're a patient man. =:^)
>>
>> Sort of... I can leave it running in the background until I come to need
>> to do something else with that machine. So... A bit of an experiment.
> 
> 
> Until... No more... And just as the gdb bt shows something a little
> different!
> 
> (gdb) bt
> #0  0x000000000041ddc4 in btrfs_comp_keys ()
> #1  0x00000000004208e9 in btrfs_search_slot ()
> #2  0x0000000000427bb4 in btrfs_read_block_groups ()
> #3  0x0000000000423e40 in btrfs_setup_all_roots ()
> #4  0x000000000042406d in __open_ctree_fd ()
> #5  0x0000000000424126 in open_ctree_fs_info ()
> #6  0x000000000041812e in cmd_check ()
> #7  0x0000000000404904 in main ()
> 
> 
> Nearly done or weeks yet more to run?
> 
> The poor thing gets killed in the morning for new work.

OK, so that all came to naught and it got killed for a kernel update and
new work.

"Just for a giggle," I tried mounting that disk with the 'recovery'
option and it failed with the usual complaint:

btrfs: disabling disk space caching
btrfs: enabling auto recovery
parent transid verify failed on 911904604160 wanted 17448 found 17450
parent transid verify failed on 911904604160 wanted 17448 found 17450
btrfs: open_ctree failed


Trying a wild guess of "btrfs-zero-log /dev/sdc" gives:

parent transid verify failed on 911904604160 wanted 17448 found 17450
parent transid verify failed on 911904604160 wanted 17448 found 17450
parent transid verify failed on 911904604160 wanted 17448 found 17450
parent transid verify failed on 911904604160 wanted 17448 found 17450
Ignoring transid failure

... and it is sat there at 100% CPU usage, no further output, and no
apparent disk activity... Just like btrfsck was...


So... Looks like time finally for a reformat.



Any chance of outputting some indication of progress, and for a speedup,
or options for partial recovery or?... Or for a fast 'slash-and-burn'
recovery where damaged trees get cleanly amputated rather than
too-painfully-slowly repaired?...

Just a few wild ideas ;-)


Regards,
Martin




