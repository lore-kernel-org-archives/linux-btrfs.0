Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41446 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755642AbbFLQX0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 12:23:26 -0400
Message-ID: <557B076B.7050500@fb.com>
Date: Fri, 12 Jun 2015 12:23:07 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC] btrfs: csum: Introduce partial csum for tree block.
References: <1434078015-8868-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1434078015-8868-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/11/2015 11:00 PM, Qu Wenruo wrote:
> Introduce the new partial csum mechanism for tree block.
> 
> [Old tree block csum]
> 0     4     8    12    16    20    24    28    32
> -------------------------------------------------
> |csum |   unused, all 0				|
> -------------------------------------------------
> Csum is the crc32 of the whole tree block data.
> 
> [New tree block csum]
> -------------------------------------------------
> |csum0|csum1|csum2|csum3|csum4|csum5|csum6|csum7|
> -------------------------------------------------
> Where csum0 is the same as the old one, crc32 of the whole tree block
> data.
> 
> But csum1~csum7 will restore crc32 of each eighth part.
> Take example of 16K leafsize, then:
> csum1: crc32 of BTRFS_CSUM_SIZE~4K
> csum2: crc32 of 4K~6K
> ...
> csum7: crc32 of 14K~16K
> 
> This provides the ability for btrfs not only to detect corruption but
> also to know where corruption is.
> Further improve the robustness of btrfs.
> 
> Although the best practise is to introduce new csum type and put every
> eighth crc32 into corresponding place, but the benefit is not worthy to
> break the backward compatibility.
> So keep csum0 and modify csum1 range to keep backward compatibility.

I do like how you're maintaining compatibility here, but I'm curious if
you have data about situations this is likely to help?  Is there a
particular kind of corruption you're targeting?

Or is the goal to prevent tossing the whole block, and try to limit it
to a smaller set of items in a node?

-chris

