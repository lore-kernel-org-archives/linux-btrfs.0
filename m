Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53858 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984AbaBKNZt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 08:25:49 -0500
Message-ID: <52FA24CB.3070103@fb.com>
Date: Tue, 11 Feb 2014 08:25:31 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfstests: btrfs/004: fix to make test really work
References: <1392113204-29237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1392113204-29237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/11/2014 05:06 AM, Wang Shilong wrote:
> So i was wondering why test 004 could pass my previous wrong
> kernel patch while it defenitely should not.
>
> By some debugging, i found here perl script is wrong, we did not
> filter out anything and this unit test did not work acutally.so
> it came out we will never fail this test.
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---

This works for me, you can add

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
