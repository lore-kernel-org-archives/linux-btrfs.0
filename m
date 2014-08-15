Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10705 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbaHOQFG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Aug 2014 12:05:06 -0400
Message-ID: <53EE2FAC.7080704@fb.com>
Date: Fri, 15 Aug 2014 12:05:00 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] Btrfs: fix task hang under heavy compressed write
References: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com> <1408117013-305-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1408117013-305-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/15/2014 11:36 AM, Liu Bo wrote:

[ snip ]
> 
> Besides, there're other cases that can lead to deadlock, but the real problem
> is that all btrfs workqueue shares one work->func, -- normal_work_helper,
> so this makes each workqueue to have its own helper function, but only a
> wraper pf normal_work_helper.
> 
> With this patch, I no long hit the above hang.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v3:
>   - Adopting Chris's advice, this has each workqueue provide its own helper
>     function.
>   - This is rebased on the latest Chris's for-linus branch.

This is what I had in mind, thanks Liu! I'll test and queue it up for rc2.

-chris
