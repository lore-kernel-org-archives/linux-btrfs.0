Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1571 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbaFRPYU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 11:24:20 -0400
Message-ID: <53A1AF1C.6070204@fb.com>
Date: Wed, 18 Jun 2014 08:24:12 -0700
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] xfstests/btrfs: add qgroup rescan stress test
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1399615343-28544-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <53A14F86.9000506@cn.fujitsu.com>
In-Reply-To: <53A14F86.9000506@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/18/2014 01:36 AM, Wang Shilong wrote:
> Hello Josef,
>
> The lastest Qgroup code still break this test sometimes.
>
> Ps: this test seems not merging into xfstests.
>

Yeah Chris said something about this yesterday, I'll try and get a vm up 
and running on my laptop soon and take a look at this.  Just resend this 
to the fstests list and make sure to include my reviewed-by, this test 
is super important.  Thanks,

Josef
