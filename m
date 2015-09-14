Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26029 "EHLO
	m0041696.ppops.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751302AbbINMu5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 08:50:57 -0400
Date: Mon, 14 Sep 2015 08:50:44 -0400
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: Filipe Manana <fdmanana@kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix read corruption of compressed and shared
 extents
Message-ID: <20150914125044.GA11307@ret.masoncoding.com>
References: <1442219346-14641-1-git-send-email-fdmanana@kernel.org>
 <55F68E92.2000203@cn.fujitsu.com>
 <CAL3q7H4q_sw+01+LVYa7FszFHsUy2XFb13C8LfXuS4SJk3LuLA@mail.gmail.com>
 <55F6948A.4060203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <55F6948A.4060203@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 14, 2015 at 05:34:02PM +0800, Qu Wenruo wrote:
> >>And in your case:
> >>(With a little modification, decompressed length is 32K now)
> >>     File layout
> >>     [0 - 8K]                      [8K - 24K]
> >>         |                             |
> >>         |                             |
> >>      points to extent X,         points to extent X,
> >>      offset 4K, length of 8K     offset 0, length 16K
> >>
> >>     [extent X, compressed length = 4K uncompressed length = 32K]
> >>
> >>We want to read [4K,12K) and [0,16K) of uncompressed extent X,
> >>then the real needed max range will be [0,16K).
> >>
> >>So submit one bio to read the extent, then extract the first 16K.
> >>Then copy [4K,12K) into pages for first extent, and [0,16K) for 2nd.
> >>
> >>Any idea for such enhancement?
> >
> >Yes, but I really didn't like the complexity of such solution (I tried
> >something similar) and didn't saw any significant overhead in my
> >testing that justifies it.
> >
> >thanks
> 
> Right, I didn't take block layer into consideration.
> That's what block layer should do and it has already done it well.
> 
> So I'm completely OK with your fix, especially for your nice and clear
> comment in the code.

Yeah, I'd rather keep it simple until we have workloads that are hitting
a performance problem here.

-chris
