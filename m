Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59471 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411AbcGNQVo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jul 2016 12:21:44 -0400
Subject: Re: [PATCH] btrfs: allocate exact page array size in extent_buffer
To: David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1468499372-24687-1-git-send-email-dsterba@suse.com>
CC: <chandan@linux.vnet.ibm.com>
From: Chris Mason <clm@fb.com>
Message-ID: <d2f8e9f2-9378-2ed4-74b4-eab3857c67fe@fb.com>
Date: Thu, 14 Jul 2016 12:21:31 -0400
MIME-Version: 1.0
In-Reply-To: <1468499372-24687-1-git-send-email-dsterba@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/14/2016 08:29 AM, David Sterba wrote:
> The calculation of extent_buffer::pages size was done for 4k PAGE_SIZE,
> but this wastes 15 unused pointers on arches with large page size. Eg.
> on ppc64 this gives 15 * 8 = 120 bytes.
>
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Chris Mason <clm@fb.com>

-chris
