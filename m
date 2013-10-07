Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34292 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab3JGO47 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 10:56:59 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VTCEz-0005Bx-KQ
	for linux-btrfs@vger.kernel.org; Mon, 07 Oct 2013 16:56:57 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 16:56:57 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 16:56:57 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: btrfsck --repair --init-extent-tree: segfault error 4
Date: Mon, 07 Oct 2013 15:56:44 +0100
Message-ID: <l2ui33$vjd$1@ger.gmane.org>
References: <l27agq$u5a$1@ger.gmane.org> <l27mn1$squ$1@ger.gmane.org> <l2826k$1uc$1@ger.gmane.org> <pan$69794$b0c00066$a4aa3035$c87a3c3d@cox.net> <l2a635$37m$1@ger.gmane.org> <l2ietn$jv1$1@ger.gmane.org> <l2k7kd$1dh$1@ger.gmane.org> <l2mnmf$us$1@ger.gmane.org> <l2otcg$mh$1@ger.gmane.org> <l2p3ja$v8r$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <l2p3ja$v8r$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any clues or educated comment please?

Can the corrupt directory tree safely be ignored and left in place? Or
might that cause everything to fall over in a big heap as soon as I try
to write data again?


Could these other tricks work-around or fix the corrupt tree:

Run a scrub?

Make a snapshot and work from the snapshot?

Or try "mount -o recovery,noatime" again?


Or is it dead?

(The 1.5TB of backup data is replicated elsewhere but it would be good
to rescue this version rather than completely redo from scratch.
Especially so for the sake of just a few MBytes of one corrupt directory
tree.)

Thanks,
Martin



On 05/10/13 14:18, Martin wrote:
> So...
> 
> The hint there is "btrfsck: extent-tree.c:2736", so trying:
> 
> btrfsck --repair --init-extent-tree /dev/sdc
> 
> That ran for a while until:
> 
> kernel: btrfsck[16610]: segfault at cc ip 000000000041d2a7 sp
> 00007fffd2c2d710 error 4 in btrfsck[400000+4d000]
> 
> There's no other messages in the syslog.
> 
> The output attached.
> 
> 
> What next?
> 
> 
> Thanks,
> Martin
> 
> 
> 
> On 05/10/13 12:32, Martin wrote:
>> No comment so blindly trying:
>>
>> btrfsck --repair /dev/sdc
>>
>> gave the following abort:
>>
>> btrfsck: extent-tree.c:2736: alloc_reserved_tree_block: Assertion
>> `!(ret)' failed.
>>
>> Full output attached.
>>
>>
>> All on:
>>
>> 3.11.2-gentoo
>> Btrfs v0.20-rc1-358-g194aa4a
>>
>> For a 2TB single HDD formatted with defaults.
>>
>>
>> What next?
>>
>> Thanks,
>> Martin
>>
>>
>>
>>
>>>> In the meantime, trying:
>>>>
>>>> btrfsck /dev/sdc
>>>>
>>>> gave the following output + abort:
>>>>
>>>> parent transid verify failed on 915444523008 wanted 16974 found 13021
>>>> Ignoring transid failure
>>>> btrfsck: cmds-check.c:1066: process_file_extent: Assertion `!(rec->ino
>>>> != key->objectid || rec->refs > 1)' failed.
>>>> id not match free space cache generation (1625)
>>>> free space inode generation (0) did not match free space cache
>>>> generation (1607)
>>>> free space inode generation (0) did not match free space cache
>>>> generation (1604)
>>>> free space inode generation (0) did not match free space cache
>>>> generation (1606)
>>>> free space inode generation (0) did not match free space cache
>>>> generation (1620)
>>>> free space inode generation (0) did not match free space cache
>>>> generation (1626)
>>>> free space inode generation (0) did not match free space cache
>>>> generation (1609)
>>>> free space inode generation (0) did not match free space cache
>>>> generation (1653)
>>>> free space inode generation (0) did not match free space cache
>>>> generation (1628)
>>>> free space inode generation (0) did not match free space cache
>>>> generation (1628)
>>>> free space inode generation (0) did not match free space cache
>>>> generation (1649)
>>>>
>>>>
>>>> (There was no syslog output.)
>>>>
>>>> Full btrfsck listing attached.
>>>>
>>>>
>>>> Suggestions please?
>>>>
>>>> Thanks,
>>>> Martin



