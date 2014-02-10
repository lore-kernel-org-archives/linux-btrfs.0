Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22985 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752179AbaBJVap (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 16:30:45 -0500
Message-ID: <52F944F9.7080500@fb.com>
Date: Mon, 10 Feb 2014 16:30:33 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>, <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>, <david@fromorbit.com>
Subject: Re: [PATCH v4] xfstests/btrfs: add a regression test for running
 snapshot and send concurrently
References: <1391781656-9469-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1391781656-9469-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/07/2014 09:00 AM, Wang Shilong wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> Btrfs would fail to send if snapshot run concurrently, this test is to make
> sure we have fixed the bug.
>
>

Looks reasonable, ran it with and without the patch and it did as expected.

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
