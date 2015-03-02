Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28929 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755306AbbCBVuu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Mar 2015 16:50:50 -0500
Message-ID: <54F4DB34.5000004@fb.com>
Date: Mon, 2 Mar 2015 16:50:44 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/7] btrfs: Don't allow subvolid >= (1 << BTRFS_QGROUP_LEVEL_SHIFT)
 to be created
References: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com> <1425025468-29749-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025468-29749-3-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/27/2015 03:24 AM, Qu Wenruo wrote:
> Btrfs will create qgroup on subvolume creation if quota is enabled, but
> qgroup uses the high bits(currently 16 bits) as level, to build the
> inheritance.
>
> However it is fully possible a subvolume can be created with a
> subvolumeid larger than 1 << BTRFS_QGROUP_LEVEL_SHIFT, so it will be
> considered as level 1 and can't be assigned to other qgroup in level 1.
>
> This patch will prevent such things so qgroup inheritance will not be
> screwed up.
> The downside is very clear, btrfs subvolume number limit will decrease
> from (u64 max - 256(fisrt free objectid) - 256(last free objectid)) to
> (u48 max -256(first free objectid)).
> But we still have near u48(that's 15 digits in dec), so that should not
> be a huge problem.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
