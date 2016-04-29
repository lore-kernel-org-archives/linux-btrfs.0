Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13350 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816AbcD2Nyy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 09:54:54 -0400
Subject: Re: [PATCH RFC v2 00/16] Introduce low memory usage btrfsck mode
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1461914350-19875-1-git-send-email-quwenruo@cn.fujitsu.com>
 <56c6051d-74fd-6152-c5cc-65e1a9595b00@cn.fujitsu.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <c7584cf8-fb09-5a7d-6b99-1238932550bf@fb.com>
Date: Fri, 29 Apr 2016 09:54:47 -0400
MIME-Version: 1.0
In-Reply-To: <56c6051d-74fd-6152-c5cc-65e1a9595b00@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/29/2016 03:27 AM, Qu Wenruo wrote:
> Hi Josef,
>
> Thanks for your previous review.
>
> I'd like to add your reviewed-by tag only after we have settled down the
> main part of the patchset and get rid of the "RFC" tag.
>
> Will it be OK for you?

That's fine with me, but I think having a non-caching version is 
valuable for low-memory situations so I don't really have a problem with 
the idea overall.  I'll reserve final judgment until after I've made it 
through the whole series but I feel pretty confident this is a good 
approach overall.  Thanks,

Josef

