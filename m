Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34507 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754416AbbCBVzl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Mar 2015 16:55:41 -0500
Message-ID: <54F4DC57.4040602@fb.com>
Date: Mon, 2 Mar 2015 16:55:35 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 5/7] btrfs: qgroup: clear STATUS_FLAG_ON in disabling
 quota.
References: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com> <1425025468-29749-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025468-29749-6-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/27/2015 03:24 AM, Qu Wenruo wrote:
> From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>
> we forgot to clear STATUS_FLAG_ON in quota_disable(), it
> will cause a problem shown as below:
>
> 	# mount /dev/sdc /mnt
> 	# btrfs quota enable /mnt
> 	# btrfs quota disable /mnt
> 	# btrfs quota rescan /mnt
> 	quota rescan started <--- expecting it fail here.
> 	# echo $?
> 	0
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
