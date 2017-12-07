Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33840 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752252AbdLGA0f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Dec 2017 19:26:35 -0500
Date: Wed, 6 Dec 2017 16:26:24 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] Btrfs: make raid6 rebuild retry more
Message-ID: <20171207002624.GC30109@dhcp-whq-twvpn-1-vpnpool-10-159-141-111.vpn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <20171204224037.7556-1-bo.li.liu@oracle.com>
 <20171204224037.7556-4-bo.li.liu@oracle.com>
 <1ab2da20-6294-67a4-2ef3-6a65afed0fc6@gmx.com>
 <20171205180925.GO3553@twin.jikos.cz>
 <20171205225501.GC18865@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <2958e696-4671-73a4-5940-2b9a89627150@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <2958e696-4671-73a4-5940-2b9a89627150@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 06, 2017 at 08:11:30AM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年12月06日 06:55, Liu Bo wrote:
> > On Tue, Dec 05, 2017 at 07:09:25PM +0100, David Sterba wrote:
> >> On Tue, Dec 05, 2017 at 04:07:35PM +0800, Qu Wenruo wrote:
> >>>> @@ -2166,11 +2166,21 @@ int raid56_parity_recover(struct btrfs_fs_info *fs_info, struct bio *bio,
> >>>>  	}
> >>>>  
> >>>>  	/*
> >>>> -	 * reconstruct from the q stripe if they are
> >>>> -	 * asking for mirror 3
> >>>> +	 * Loop retry:
> >>>> +	 * for 'mirror == 2', reconstruct from all other stripes.
> >>>
> >>> What about using macro to makes the reassemble method more human readable?
> >>
> >> Yeah, that's definetelly needed and should be based on
> >> BTRFS_MAX_MIRRORS, not just hardcoded to 3.
> > 
> > OK.
> > 
> > In case of raid5/6, BTRFS_MAX_MIRRORS is an abused name, it's more a
> > raid1/10 concept, either BTRFS_RAID56_FULL_REBUILD or
> > BTRFS_RAID56_FULL_CHK is better to me, which one do you guys like?
> 
> For mirror > 2 case, the mirror_num is no longer a single indicator, but
> a ranged iterator for later rebuild retries.
> 
> Something like set_raid_fail_from_mirror_num() seems better to me.

I feel like having the logic open-code'd plus necessary comments is
probably better as we can see which stripe failb is.

For those who are new to this raid6 retry logic are likely to feel
confused by a helper function like set_raid_fail_from_mirror_num() and
will go check the helper function about the retry logic.

Thanks,

-liubo
