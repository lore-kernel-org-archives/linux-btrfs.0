Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:35410 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932629AbcLSSyP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 13:54:15 -0500
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 3F9AF60040
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Dec 2016 19:54:13 +0100 (CET)
Subject: Re: Btrfs Heatmap - v3 - scriptable .. more flexible
To: linux-btrfs@vger.kernel.org
References: <0ad8cf30-04bb-40d3-9929-388eb26a765e@mendix.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <408eeebc-58b5-f783-a17a-68d2678b2372@mendix.com>
Date: Mon, 19 Dec 2016 19:54:13 +0100
MIME-Version: 1.0
In-Reply-To: <0ad8cf30-04bb-40d3-9929-388eb26a765e@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rereading this...

On 12/19/2016 12:53 AM, Hans van Kranenburg wrote:
> [...]
> 
> Qu Wenruo pointed out that the greyscale value used for dev_extent (the
> usage for the block group is used here) does not necessarily have to be
> correct: "And for 50%/50% assumption for RAID0, it's not true and we can
> easily create a case where it's 100%/0%". (Qu)
> 
> I replied on that with "OTOH, for most cases it will still be correct
> enough for the eye, because statistically seen, distribution of data
> over the stripes will be more uniform more often than not".
> 
> Still, "The point is, for full fs or per-device output, a developer may
> focus on the fragments of unallocated space in each device." (Qu)

What does "unallocated" mean here?

I always use "unallocated" for space that is not part of a
dev_extent/chunk/blockgroup at all, and "unused" for free space inside
allocated space.

> The last commit, "Don't hardcode minimal brightness for dev_extents"
> exposes the min_brightness, which tunes the brightness range of
> allocated space. "Setting it to 255 will cause any allocated space to
> show up as bright white, regardless of usage."

If meant as unused free space in allocated dev_extent space, then this
does not help much of course.

OTOH, I don't think the information of data distribution over
dev_extents belonging to a single blockgroup is available at all, when
walking the IOCTL paths.

-- 
Hans van Kranenburg
