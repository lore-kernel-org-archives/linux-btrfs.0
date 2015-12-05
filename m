Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57564 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbbLEGx0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Dec 2015 01:53:26 -0500
Subject: Re: BUG: failure at fs/btrfs/ctree.h:337/btrfs_chunk_item_size()!
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Vegard Nossum <vegard.nossum@oracle.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <5648CD1D.9070804@oracle.com>
 <20151130134851.GZ31035@twin.jikos.cz> <20151130163407.GA31035@twin.jikos.cz>
 <565CC820.9020706@oracle.com> <565CEEF1.80006@cn.fujitsu.com>
 <20151203174714.GD31035@suse.cz> <5660EAB7.1020702@cn.fujitsu.com>
 <20151204131229.GG31035@suse.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <566289C6.5050804@gmx.com>
Date: Sat, 5 Dec 2015 14:52:54 +0800
MIME-Version: 1.0
In-Reply-To: <20151204131229.GG31035@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/04/2015 09:12 PM, David Sterba wrote:
> On Fri, Dec 04, 2015 at 09:21:59AM +0800, Qu Wenruo wrote:
>>> We do have the alignment check in kernel, but it's in the early phase
>>> where we don't know if nodesize is reliable and print only a warning.
>>>
>> This can be enhanced by the following method:
>
> At minimum, we can promote the 4k alignment checks in
> btrfs_check_super_valid from a warning to an error. The blocks must be
> 4k aligned, regardless of sectorsize or nodesize.
>
>> 1) Check sectorsize first
>>      Only several sector size is valid for current btrfs:
>>      4K, 8K, 16K, 32K, 64K
>>      Just five numbers, quite easy to check.
>
> The sectorsize must be PAGE_SIZE at the moment. This will change with
> Chandan's patchset though.

PAGE_SIZE would be good enough.

>
>>      Or if anyone is going to extend supported sectorsize, we can change
>>      the check to if the number is power of 2 starting from 4K.
>>
>> 2) Check nodesize/leafsize then
>>      It should be aligned to sectorsize.
>
> This particular check is missing but is implicit because of the
> sectorsize == PAGE_SIZE restriction.

But still need to check nodesize/leafsize validation against sectorsize.
Current btrfs is already using large nodesize by default.

For example, 20K nodesize can pass 4K page size check but still wrong.

(And I'm also wrong in previous mail, it's not only aligned to 
sectorisze, but also need to be power of 2)

>
>>      And nodesize must match with leafsize.
>>      Currently, it's done out of check_super_valid(), we can integrate it.
>
> Yeah it's done, then I don't see why we should add it agian.

Just want to move it to check_super_valid(), as it's better to put 
validation check codes together, and that's why we have check_super_valid().

>
>> 3) Check all super root bytenr against *sectorsize*
>>      Yeah, not nodesize.
>>      As some old bad convert will cause metadata extent unaligned to
>>      nodesize(just before my convert rework patch), but only aligned to
>>      sectorsize.
>>      So only check alignment of sectorsize.
>
> While the real check should be against the sectorsize, at the moment I
> think it's covered by the 4k checks anyway. I understand why we can't
> use the nodesize.
>

4K is good enough for x86 family but can't find all problem for 64K page 
size like PPC64 or AArch64.

So it's still better to change the check at least to page size even we 
don't have subpage size support yet.

> So, if we do the warning -> error, we're fine for now. Some of the
> checks you suggest would be good to merge when the subpage blocksize
> patchset is merged.

Right, more accurate check is only needed after subpage patchset.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
