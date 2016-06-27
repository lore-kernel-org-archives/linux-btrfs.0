Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26101 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751639AbcF0NEO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 09:04:14 -0400
Subject: Re: [PATCH 05/14] Btrfs: warn_on for unaccounted spaces
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Josef Bacik <jbacik@fb.com>,
        <linux-btrfs@vger.kernel.org>
References: <1458926760-17563-1-git-send-email-jbacik@fb.com>
 <1458926760-17563-6-git-send-email-jbacik@fb.com>
 <d8055e61-f36f-f7d8-8963-e84532a0e31a@cn.fujitsu.com>
From: Chris Mason <clm@fb.com>
Message-ID: <992d9eb6-a779-e104-fa84-007838e53701@fb.com>
Date: Mon, 27 Jun 2016 09:03:27 -0400
MIME-Version: 1.0
In-Reply-To: <d8055e61-f36f-f7d8-8963-e84532a0e31a@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/27/2016 12:47 AM, Qu Wenruo wrote:
> Hi Josef,
>
> Would you please move this patch to the first of the patchset?
>
> It's making bisect quite hard, as it will always stop at this patch,
> hard to check if it's a regression or existing bug.

That's a good idea.  Which workload are you having trouble with?

-chris
