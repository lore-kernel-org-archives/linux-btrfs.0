Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45240 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab3JDPne (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Oct 2013 11:43:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VS7XQ-0004JB-IF
	for linux-btrfs@vger.kernel.org; Fri, 04 Oct 2013 17:43:32 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Oct 2013 17:43:32 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Oct 2013 17:43:32 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Corrupt btrfs filesystem recovery... What best instructions?
Date: Fri, 04 Oct 2013 16:43:20 +0100
Message-ID: <l2mnmf$us$1@ger.gmane.org>
References: <l27agq$u5a$1@ger.gmane.org> <l27mn1$squ$1@ger.gmane.org> <l2826k$1uc$1@ger.gmane.org> <pan$69794$b0c00066$a4aa3035$c87a3c3d@cox.net> <l2a635$37m$1@ger.gmane.org> <l2ietn$jv1$1@ger.gmane.org> <l2k7kd$1dh$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <l2k7kd$1dh$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What best to try next?

mount "-o recovery,noatime"

btrfsck:
    --repair                    try to repair the filesystem
    --init-csum-tree            create a new CRC tree
    --init-extent-tree          create a new extent tree

or is a "scrub" worthwhile?


The fail and switch to read-only occured whilst trying to delete a known
bad directory tree. No worries for losing the data in that.

But how best to clean up the filesystem errors?


Thanks,
Martin




On 03/10/13 17:56, Martin wrote:
> On 03/10/13 01:49, Martin wrote:
> 
>> Summary:
>>
>> Mounting "-o recovery,noatime" worked well and allowed a diff check to
>> complete for all but one directory tree. So very nearly all the data is
>> fine.
>>
>> Deleting the failed directory tree caused a call stack dump and eventually:
>>
>> kernel: parent transid verify failed on 915444822016 wanted 16974 found
>> 13021
>> kernel: BTRFS info (device sdc): failed to delete reference to
>> eggdrop-1.6.19.ebuild, inode 2096893 parent 5881667
>> kernel: BTRFS error (device sdc) in __btrfs_unlink_inode:3662: errno=-5
>> IO failure
>> kernel: BTRFS info (device sdc): forced readonly
>>
>>
>> Greater detail listed below.
>>
>> What next best to try?
>>
>> Safer to try again but this time with with "no_space_cache,no_inode_cache"?
>>
>> Thanks,
>> Martin
> 
> 
>> Next best step to try?
>>
>> Remount "-o recovery,noatime" again?
> 
> 
> In the meantime, trying:
> 
> btrfsck /dev/sdc
> 
> gave the following output + abort:
> 
> parent transid verify failed on 915444523008 wanted 16974 found 13021
> Ignoring transid failure
> btrfsck: cmds-check.c:1066: process_file_extent: Assertion `!(rec->ino
> != key->objectid || rec->refs > 1)' failed.
> id not match free space cache generation (1625)
> free space inode generation (0) did not match free space cache
> generation (1607)
> free space inode generation (0) did not match free space cache
> generation (1604)
> free space inode generation (0) did not match free space cache
> generation (1606)
> free space inode generation (0) did not match free space cache
> generation (1620)
> free space inode generation (0) did not match free space cache
> generation (1626)
> free space inode generation (0) did not match free space cache
> generation (1609)
> free space inode generation (0) did not match free space cache
> generation (1653)
> free space inode generation (0) did not match free space cache
> generation (1628)
> free space inode generation (0) did not match free space cache
> generation (1628)
> free space inode generation (0) did not match free space cache
> generation (1649)
> 
> 
> (There was no syslog output.)
> 
> Full btrfsck listing attached.
> 
> 
> Suggestions please?
> 
> Thanks,
> Martin



