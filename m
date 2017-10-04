Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:54773 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751133AbdJDVmJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Oct 2017 17:42:09 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH] btrfs: avoid overflow when sector_t is 32 bit
To: bo.li.liu@oracle.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Jean-Denis Girard <jd.girard@sysnux.pf>,
        Goffredo Baroncelli <kreijack@inwind.it>
References: <20171003173110.14789-1-kreijack@libero.it>
 <20171004142228.GB3521@twin.jikos.cz>
 <20171004171350.GA4902@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <68569aa6-8489-c7b0-4f90-43588f567d32@libero.it>
Date: Wed, 4 Oct 2017 23:42:04 +0200
MIME-Version: 1.0
In-Reply-To: <20171004171350.GA4902@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/04/2017 07:13 PM, Liu Bo wrote:
> On Wed, Oct 04, 2017 at 04:22:28PM +0200, David Sterba wrote:
>> On Tue, Oct 03, 2017 at 07:31:10PM +0200, Goffredo Baroncelli wrote:
>>> From: Goffredo Baroncelli <kreijack@inwind.it>
>>>
>>> Jean-Denis Girard noticed commit c821e7f3 "pass bytes to
>>> btrfs_bio_alloc" (https://patchwork.kernel.org/patch/9763081/) introduces a
>>> regression on 32 bit machines.
>>> When CONFIG_LBDAF is _not_ defined (CONFIG_LBDAF == Support for large
>>> (2TB+) block devices and files) sector_t is 32 bit on 32bit machines.
>>>
>>> In the function submit_extent_page, 'sector' (which is sector_t type) is
>>> multiplied by 512 to convert it from sectors to bytes, leading to an
>>> overflow when the disk is bigger than 4GB (!).
>>
>> That's not good. There are some known typedefs that hide the 32bit/64bit
>> differences but the LBDAF and sector_t is new to me. Thanks for the
>> report and fix, I'll get it to linus/master tree in the next batch so it
>> can go to stable tree.
>>
>> I've seen sector_t used in places where it is not necessary so I'll try
>> to minimize the usage and more surprises from the << 9 shifts.
>>
>> Reviewed-by: David Sterba <dsterba@suse.com>
>> Fixes: c821e7f3 ("btrfs: pass bytes to btrfs_bio_alloc")
>> CC: stable@vger.kernel.org # 4.13+
> 
> However, this sector_t is passed from its callers, e.g.
> 
> __do_readpage()
> {
> 	sector_t sector;
> 	...
> 	sector = em->block_start >> 9;
> 	...
> }
> 
> if sector_t is 32bit, the above %sector could also lose high bits.
> Some cleanups are needed to use u64 directly.

If sector_t is  32bit, the kernel can't access disk bigger than 2TB. So I suppose that block_start is less than 4GB.
> 
> Even with this patch, I suspect that there might be errors from block
> layer as sector_t is used everywhere in block layer.
> 
> For a btrfs FS that is created and used on 64bit system, it'll be
> causing trouble anyway if letting it mount 32bit system, lets refuse
> the mount firstly.

I think that the check should be:

if sizeof(sector_t) < 8 && filesystem_end > 2TB then
	do_not_mount_it


I am not sure what the other fs does

> 
> Thanks,
> 
> -liubo
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
