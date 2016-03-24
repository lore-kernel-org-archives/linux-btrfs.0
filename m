Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48237 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbcCXUfQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 16:35:16 -0400
Date: Thu, 24 Mar 2016 16:35:04 -0400
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v8 25/27] btrfs: dedupe: Add support for compression and
 dedpue
Message-ID: <20160324203504.m2b3lybguuf5r2hd@floor.thefacebook.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1458610552-9845-26-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1458610552-9845-26-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 22, 2016 at 09:35:50AM +0800, Qu Wenruo wrote:
> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> 
> The basic idea is also calculate hash before compression, and add needed
> members for dedupe to record compressed file extent.
> 
> Since dedupe support dedupe_bs larger than 128K, which is the up limit
> of compression file extent, in that case we will skip dedupe and prefer
> compression, as in that size dedupe rate is low and compression will be
> more obvious.
> 
> Current implement is far from elegant. The most elegant one should split
> every data processing method into its own and independent function, and
> have a unified function to co-operate them.

I'd leave this one out for now, it looks like we need to refine the
pipeline from dedup -> compression and this is just more to carry around
until the initial support is in.  Can you just decline to dedup
compressed extents for now?

-chris
