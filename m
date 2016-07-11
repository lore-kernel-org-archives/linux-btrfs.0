Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33605 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750986AbcGKWyT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 18:54:19 -0400
Date: Mon, 11 Jul 2016 18:54:02 -0400
From: Chris Mason <clm@fb.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3] Btrfs: fix eb memory leak due to readpage failure
Message-ID: <20160711225402.GA43165@clm-mbp.thefacebook.com>
References: <1464980918-8365-1-git-send-email-bo.li.liu@oracle.com>
 <1468258747-19617-1-git-send-email-bo.li.liu@oracle.com>
 <a24aa67a-1880-64d5-1e09-7682e838141a@fb.com>
 <20160711224838.GA27394@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <20160711224838.GA27394@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 03:48:38PM -0700, Liu Bo wrote:
>On Mon, Jul 11, 2016 at 02:27:39PM -0400, Chris Mason wrote:
>>
>>
>> On 07/11/2016 01:39 PM, Liu Bo wrote:
>> > eb->io_pages is set in read_extent_buffer_pages().
>> >
>> > In case of readpage failure, for pages that have been added to bio,
>> > it calls bio_endio and later readpage_io_failed_hook() does the work.
>> >
>> > When this eb's page (couldn't be the 1st page) fails to add itself to bio
>> > due to failure in merge_bio(), it cannot decrease eb->io_pages via bio_endio,
>> >  and ends up with a memory leak eventually.
>> >
>> > This lets __do_readpage propagate errors to callers and adds the
>> >  'atomic_dec(&eb->io_pages)'.
>>
>> Thanks for looking at this Liu, how is it currently being tested?
>
>I have a btrfs disk image which was corrupted by btrfs-corrupt-block
>tool, in that image, the chunk tree's content has been removed while the
>chunk node can be read from read successfully, so we'd get -EIO when
>trying to read tree root's node since __btrfs_map_block() would fail to
>find the right item in chunk mapping_tree.  Thus, we can test our error
>handling path in read_extent_buffer_pages().

Fantastic.  Can you please make this an xfstest, maybe along with a dm-flakey?
as the second phase?

-chris

