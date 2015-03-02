Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46002 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754139AbbCBWDe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Mar 2015 17:03:34 -0500
Message-ID: <54F4DE2F.3030200@fb.com>
Date: Mon, 2 Mar 2015 17:03:27 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 7/7] btrfs: quota: Update quota tree after qgroup relationship
 change.
References: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com> <1425025468-29749-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025468-29749-8-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/27/2015 03:24 AM, Qu Wenruo wrote:
> Previous patch modified the in memory struct but it's not written in
> quota tree until next commit.
> So user will still get old data using "btrfs qgroup show" after
> assign/remove.
>
> This patch will call btrfs_run_qgroups in assign ioctl so it will be
> updated to in memory quota trees and user will get up-to-date results.
>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

