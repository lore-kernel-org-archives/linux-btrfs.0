Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46721 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933242AbcIVO3H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 10:29:07 -0400
Subject: Re: deadlock with btrfs heavy i/o and kswapd
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <281582c9-1307-612e-77e6-9d768337ea3e@profihost.ag>
From: Chris Mason <clm@fb.com>
Message-ID: <8116272d-6c30-431a-c3e1-781b17bea2c6@fb.com>
Date: Thu, 22 Sep 2016 10:28:43 -0400
MIME-Version: 1.0
In-Reply-To: <281582c9-1307-612e-77e6-9d768337ea3e@profihost.ag>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/22/2016 02:41 AM, Stefan Priebe - Profihost AG wrote:
> Hi,
>
> i always encounter btrfs deadlocks / hung tasks, when i have a lot of
> cached mem and i'm doing heavy rsync --inplace operations in my system
> from btrfs zlib compressed disk A to btrfs zlib compressed disk B.
>
> The last output i see in this case is kswapd0 running for a long time at
> 100% cpu. Then the whole system get's stuck. I cannot connect to ssh
> anymore but the kernel still prints hung tasks every few minutes.
>
> May be relevant the system has NO swap.
>
> vm.vfs_cache_pressure = 100
> vm.swappiness = 50

Are you able to capture the stack dumps?  A sysrq-w would really help.

-chris

