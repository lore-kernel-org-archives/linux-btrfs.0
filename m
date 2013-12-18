Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59152 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751910Ab3LRViy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 16:38:54 -0500
Message-ID: <52B215E7.7000809@fb.com>
Date: Wed, 18 Dec 2013 16:38:47 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: improve the performance fluctuating of the fsync
References: <1387363964-20316-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1387363964-20316-1-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/18/2013 05:52 AM, Miao Xie wrote:
> In order to improve the performance of fsync, we use the outstanding
> ordered extents to avoid looking up the checksum from the csum tree.
> But we didn't filter out the ordered extents whose csum is still being
> calculated, when we got those ordered extents, we had to wait for the
> csum calculation. It made the performance dropped down suddenly. (On
> my box, it drop down from 56MB/s to 4-10MB/s)
>
> But actually, the csum calculation of the ordered extents which were
> introduced by the current fsync had already completed. Those ordered
> extents whose csum was being calculated didn't belong to the current
> fsync, we can ignore them.

This isn't true because we will just start IO and carry on and wait 
later on, so we could very well have ordered extents that we started for 
this fsync without their csums ready which is why this code exists.  Thanks,

Josef
