Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47036 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756646AbcKVTPS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 14:15:18 -0500
Subject: Re: [PATCH] Btrfs: fix truncate down when no_holes feature is enabled
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1478903265-24273-1-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>, Filipe Manana <fdmanana@suse.com>
From: Chris Mason <clm@fb.com>
Message-ID: <e740caa9-33a8-7aa0-b4a4-c6fc22be4d3e@fb.com>
Date: Tue, 22 Nov 2016 14:13:21 -0500
MIME-Version: 1.0
In-Reply-To: <1478903265-24273-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/11/2016 05:27 PM, Liu Bo wrote:
> For such a file mapping,
>
> [0-4k][hole][8k-12k]
>
> In NO_HOLES mode, we don't have the [hole] extent any more.
> Commit c1aa45759e90 ("Btrfs: fix shrinking truncate when the no_holes feature is enabled")
>  fixed disk isize not being updated in NO_HOLES mode when data is not flushed.
>
> However, even if data has been flushed, we can still have trouble
> in updating disk isize since we updated disk isize to 'start' of
> the last evicted extent.
>
> Also add a ASSERT for better catching (for developers only).
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Thanks Liu!

Reviewed-by: Chris Mason <clm@fb.com>
