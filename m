Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34980 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753735AbbCBWCw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Mar 2015 17:02:52 -0500
Message-ID: <54F4DE06.3060106@fb.com>
Date: Mon, 2 Mar 2015 17:02:46 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 6/7] btrfs: quota: Automatically update related qgroups
 or mark INCONSISTENT flags when assigning/deleting a qgroup relations.
References: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com> <1425025468-29749-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025468-29749-7-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/27/2015 03:24 AM, Qu Wenruo wrote:
> Operation like qgroups assigning/deleting qgroup relations will mostly
> cause qgroup data inconsistent, since it needs to do the full rescan to
> determine whether shared extents are exclusive or still shared in
> parent qgroups.
>
> But there are some exceptions, like qgroup with only exclusive extents
> (qgroup->excl == qgroup->rfer), in that case, we only needs to
> modify all its parents' excl and rfer.
>
> So this patch adds a quick path for such qgroup in qgroup
> assign/remove routine, and if quick path failed, the qgroup status will
> be marked INCONSISTENT, and return 1 to info user-land.
>
> BTW since the quick path is much the same of qgroup_excl_accounting(),
> so move the core of it to __qgroup_excl_accounting() and reuse it.
>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
