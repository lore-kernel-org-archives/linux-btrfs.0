Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49259 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752589AbcLMTDo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Dec 2016 14:03:44 -0500
Subject: Re: [PATCH] btrfs: limit async_work allocation and worker func
 duration
To: Maxim Patlasov <mpatlasov@virtuozzo.com>, <dsterba@suse.cz>
References: <148072986343.13061.16191252239168261528.stgit@maxim-thinkpad>
 <20161212145443.GT12522@twin.jikos.cz>
 <2d4aaf16-b9b3-6cd9-d542-c74f00811c93@virtuozzo.com>
CC: <jbacik@fb.com>, <linux-kernel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <47667065-cf42-50b7-2862-d270628dc8f8@fb.com>
Date: Tue, 13 Dec 2016 14:03:31 -0500
MIME-Version: 1.0
In-Reply-To: <2d4aaf16-b9b3-6cd9-d542-c74f00811c93@virtuozzo.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/12/2016 03:35 PM, Maxim Patlasov wrote:
> On 12/12/2016 06:54 AM, David Sterba wrote:
>
> As far as we don't have any NO_THRESHOLD users of
> btrfs_workqueue_normal_congested for now, I tend to think it's better to
> add a descriptive comment and simply return "false" from
> btrfs_workqueue_normal_congested rather than trying to address some
> future needs now. See please v2 of the patch.
>

Thanks, I've got v2 and added a cc for stable to v3.15+, which isn't 
exactly right, but its when the new workqueue system was put in place.

-chris
