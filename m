Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60830 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbcD1OX2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 10:23:28 -0400
Subject: Re: [PATCH RFC 07/16] btrfs-progs: fsck: Introduce function to check
 shared data backref
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1461642543-4621-8-git-send-email-quwenruo@cn.fujitsu.com>
CC: <dsterba@suse.cz>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <e92396e1-f414-2187-c039-b827bcf5e5da@fb.com>
Date: Thu, 28 Apr 2016 10:23:20 -0400
MIME-Version: 1.0
In-Reply-To: <1461642543-4621-8-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/25/2016 11:48 PM, Qu Wenruo wrote:
> From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>
> Introduce the function check_shared_data_backref() to check the
> referencer of a given shared data backref.
>
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
