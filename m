Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54365 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755537AbcIMVBV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 17:01:21 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
References: <1471023419.16857.9.camel@gmail.com>
 <57D76FB0.4060908@cn.fujitsu.com> <1473799768.3344.1.camel@gmail.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <41e0d253-133f-ac0e-eda6-95a927736fc6@fb.com>
Date: Tue, 13 Sep 2016 17:01:06 -0400
MIME-Version: 1.0
In-Reply-To: <1473799768.3344.1.camel@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/13/2016 04:49 PM, Ronan Arraes Jardim Chagas wrote:
> Hi guys,
>
> One more time I saw the problem. It begins to happen on a daily basis
> now. Unfortunately the `enospc_debug` flag did not help. I did not see
> any new information in the logs. This time, only a hard reset worked. I
> could not even reboot using gnome panel.

I just started paying attention to this, the last kernel I saw you were running 
was 4.7.  Have you tried a recent kernel, like chris's tree?


git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.8

is what I would like you to try if not.  Thanks,

Josef
