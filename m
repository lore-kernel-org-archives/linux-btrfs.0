Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56770 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752349AbbGWNln (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 09:41:43 -0400
Date: Thu, 23 Jul 2015 09:41:35 -0400
From: Chris Mason <clm@fb.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Fix scrub panic when leaf accross stripes
Message-ID: <20150723134135.GE17832@ret.masoncoding.com>
References: <ad73b900e3183b8d7dccab6b1ad8ac754fd0c583.1437625769.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <ad73b900e3183b8d7dccab6b1ad8ac754fd0c583.1437625769.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 23, 2015 at 12:29:49PM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> Scrub panic in following operation:
>   mkfs.ext4 /dev/vdh
>   btrfs-convert /dev/vdh
>   mount /dev/vdh /mnt/tmp1
>   btrfs scrub start -B /dev/vdh
>   (panic)
> 
> Reason:
>   1: In some case, leaf created by btrfs-convert was splited into 2
>      strips.
>   2: Scrub bypassed part of above wrong leaf data, but remain data
>      caused panic in scrub_checksum_tree_block().

Thanks for tracking this one down, I've queued it up.

-chris
