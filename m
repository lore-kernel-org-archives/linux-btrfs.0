Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54044 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286AbbCBVyx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Mar 2015 16:54:53 -0500
Message-ID: <54F4DC27.1020401@fb.com>
Date: Mon, 2 Mar 2015 16:54:47 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/7] btrfs: Update btrfs qgroup status item when rescan
 is done.
References: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com> <1425025468-29749-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025468-29749-5-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/27/2015 03:24 AM, Qu Wenruo wrote:
> Update qgroup status when rescan is done.
>
> Before this patch, status item is not updated on rescan finish, which
> causing the RESCAN and INCONSISTENT flags never cleared.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
