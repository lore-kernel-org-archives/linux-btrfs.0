Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53918 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556AbbCBVwX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Mar 2015 16:52:23 -0500
Message-ID: <54F4DB91.3050404@fb.com>
Date: Mon, 2 Mar 2015 16:52:17 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/7] btrfs: qgroup: Fix dead judgement on qgroup_rescan_leaf()
 return value.
References: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com> <1425025468-29749-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025468-29749-4-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/27/2015 03:24 AM, Qu Wenruo wrote:
> Old qgroup_rescan_leaf() comment indicates ret == 2 as complete and
> cleared INCONSISTENT flag.
>
> This is not true since it will never return 2, and inside it no codes
> will clear INCONSISTENT flag.
> The flag clearance is done in btrfs_qgroup_rescan_work().
> This caused the bug that INCONSISTENT flag is never cleared.
>
> So change the comment and fix the dead judgment.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
