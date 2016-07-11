Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34991 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932127AbcGKS15 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 14:27:57 -0400
Subject: Re: [PATCH v3] Btrfs: fix eb memory leak due to readpage failure
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1464980918-8365-1-git-send-email-bo.li.liu@oracle.com>
 <1468258747-19617-1-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <a24aa67a-1880-64d5-1e09-7682e838141a@fb.com>
Date: Mon, 11 Jul 2016 14:27:39 -0400
MIME-Version: 1.0
In-Reply-To: <1468258747-19617-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/11/2016 01:39 PM, Liu Bo wrote:
> eb->io_pages is set in read_extent_buffer_pages().
>
> In case of readpage failure, for pages that have been added to bio,
> it calls bio_endio and later readpage_io_failed_hook() does the work.
>
> When this eb's page (couldn't be the 1st page) fails to add itself to bio
> due to failure in merge_bio(), it cannot decrease eb->io_pages via bio_endio,
>  and ends up with a memory leak eventually.
>
> This lets __do_readpage propagate errors to callers and adds the
>  'atomic_dec(&eb->io_pages)'.

Thanks for looking at this Liu, how is it currently being tested?

-chris
