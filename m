Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.mystoragebox.com ([173.234.39.99]:59530 "EHLO
	mail.mystoragebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaIPCXw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 22:23:52 -0400
Received: from cpe-67-240-76-244.nycap.res.rr.com ([67.240.76.244] helo=[192.168.5.80])
	by mail.mystoragebox.com with esmtpsa (TLS1.0:ECDHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.83)
	(envelope-from <markm-lists@intellasoft.net>)
	id 1XTiQm-0001rG-SN
	for linux-btrfs@vger.kernel.org; Mon, 15 Sep 2014 22:23:49 -0400
Message-ID: <54179F33.2010600@intellasoft.net>
Date: Mon, 15 Sep 2014 22:23:47 -0400
From: Mark Murawski <markm-lists@intellasoft.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs balance enospc
References: <541706ED.4010901@intellasoft.net> <20140915170722.GA9160@sune>	<541723EA.6010608@intellasoft.net>	<657EBB8A-8957-4E07-829E-171A1FF702E8@colorremedies.com> <pan$21d6d$91a64041$49bf8e34$6b7c2e69@cox.net>
In-Reply-To: <pan$21d6d$91a64041$49bf8e34$6b7c2e69@cox.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I wish i could follow your procedure, but this wasn't an ext conversion.

I made this with mkfs for btrfs with kernel circa 3.8ish


On 09/15/14 20:08, Duncan wrote:
> Chris Murphy posted on Mon, 15 Sep 2014 14:54:57 -0600 as excerpted:
>
>>> I still get enospc after a balance with a filter, and then a regular
>>> balance:
>>>
>>> cartman {~} root# btrfs balance start /
>>> ERROR: error during balancing '/' - No space left on device
>>
>> Maybe try mount option enospc_debug and retry, see if you get more
>> information in dmesg.
>>
>> I'm not sure if a balance in this case wants to create a new data and
>> metadata chunk (on each device), or if it can start without creating any
>> chunks. If it wants to create new chunks, it's 1GiB for data, and 256MiB
>> for metadata. That's 1.256GiB but you only have 1.25GiB unallocated on
>> each device: size 9.31GiB minus used 8.06GiB.
>
> Another possibility that has hit a few people:
>
> Did you (MM/OP not CM) convert that filesystem from ext* to btrfs?  If
> so, read on.  If not, this doesn't apply so you may skip it.
>
> Assuming such a conversion, did you delete the subvolume containing the
> original ext* yet, or not?  If not, that may be the problem, because that
> subvolume must be left intact in ordered to allow rollback to ext* if
> desired.  If you know you won't be rolling back, delete the ext* reserved
> subvolume as described on the wiki.
>
> Meanwhile, after deleting that subvolume, be sure to complete the defrag
> and balance as suggested on the wiki, because failing to do so can lead
> to other problems later.  Basically, the biggest extent size supported by
> btrfs is 1 GiB, the size of a btrfs data chunk, while ext* supports
> larger (unlimited size?) extents.  Failing to complete the defrag in
> particular as suggested can mean large files with extents > 1 GiB in
> size, which gives btrfs balance indigestion since it expects to see only
> 1 GiB or smaller extents.  Several folks who converted from ext3/4 have
> reported failed balances due to these too large extents, and fixing the
> problem later can require manually moving one-by-one all files large
> enough to be candidates for the problem (thus files > 1 GiB) out of btrfs
> and back in, thus resulting in properly chunk-split extents when the file
> is moved back to btrfs.  Everyone who has reported this problem so far,
> has also reported that the move out and back in process solved the
> problem for them, but if there's lots of such files it can be a pain, and
> doing the defrag on the formerly ext* files before starting to use the
> now btrfs for other things, ESPECIALLY before trying to snapshot affected
> subvolumes since that locks the problem in place until those snapshots
> are deleted, is definitely preferred. =:^)
>

