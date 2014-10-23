Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60079 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752057AbaJWJRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 05:17:48 -0400
Message-ID: <5448C81E.4060701@cn.fujitsu.com>
Date: Thu, 23 Oct 2014 17:19:26 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>,
        Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: device balance times
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com> <5446BEC0.8070009@siedziba.pl> <02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com> <5447A5CF.9060405@siedziba.pl>
In-Reply-To: <5447A5CF.9060405@siedziba.pl>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 22 Oct 2014 14:40:47 +0200, Piotr Pawłow wrote:
> On 22.10.2014 03:43, Chris Murphy wrote:
>> On Oct 21, 2014, at 4:14 PM, Piotr Pawłow<pp@siedziba.pl>  wrote:
>>> Looks normal to me. Last time I started a balance after adding 6th device to my FS, it took 4 days to move 25GBs of data.
>> It's long term untenable. At some point it must be fixed. It's way, way slower than md raid.
>> At a certain point it needs to fallback to block level copying, with a ~ 32KB block. It can't be treating things as if they're 1K files, doing file level copying that takes forever. It's just too risky that another device fails in the meantime.
> 
> There's "device replace" for restoring redundancy, which is fast, but not implemented yet for RAID5/6.

Now my colleague and I is implementing the scrub/replace for RAID5/6
and I have a plan to reimplement the balance and split it off from the metadata/file data process. the main idea is
- allocate a new chunk which has the same size as the relocated one, but don't insert it into the block group list, so we don't
  allocate the free space from it.
- set the source chunk to be Read-only
- copy the data from the source chunk to the new chunk
- replace the extent map of the source chunk with the one of the new chunk(The new chunk has
  the same logical address and the length as the old one)
- release the source chunk

By this way, we needn't deal the data one extent by one extent, and needn't do any space reservation,
so the speed will be very fast even we have lots of snapshots.

Thanks
Miao

> 
> I think the problem is that balance was originally used for balancing data / metadata split - moving stuff out of mostly empty chunks to free them and use for something else. It pretty much has to be done on the extent level.
> 
> Then balance was repurposed for things like converting RAID profiles and restoring redundancy and balancing device usage in multi-device configurations. It works, but the approach to do it extent by extent is slow.
> 
> I wonder if we could do some of these operations by just copying whole chunks in bulk. Wasn't that the point of introducing logical addresses? - to be able to move chunks around quickly without changing anything except updating chunk pointers?
> 
> BTW: I'd love a simple interface to be able to select a chunk and tell it to move somewhere else. I'd like to tell chunks with metadata, or with tons of extents: Hey, chunks! Why don't you move to my SSDs? :)
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

