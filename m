Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42467 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755235AbbCCOAx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Mar 2015 09:00:53 -0500
Message-ID: <54F5BE84.7090202@fb.com>
Date: Tue, 3 Mar 2015 09:00:36 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, <mfasheh@suse.de>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] btrfs: qgroup: fix a wrong parameter of no_quota.
References: <1423563845-9103-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1423563845-9103-4-git-send-email-yangds.fnst@cn.fujitsu.com> <54DDC62D.4070206@cn.fujitsu.com> <54EEB798.1070105@cn.fujitsu.com> <54F5988C.4020905@cn.fujitsu.com>
In-Reply-To: <54F5988C.4020905@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/03/2015 06:18 AM, Dongsheng Yang wrote:
> On 02/26/2015 02:05 PM, Dongsheng Yang wrote:
>> Wait a minute, this patch seems not working well in accounting quota
>> number when
>> deleting data shared by different subvolumes.
>>
>> I will investigate more about it and send a V2 out.
> I have sent a fstest
>   [PATCH] fstest: btrfs: add a test for quota number when deleting a
> subvol.
> for this problem I was trying to solve in this patch.
>
> Please consider reverting the two commits introduced the problem:
>
> e339a6b0 (Btrfs: __btrfs_mod_ref should always use no_quota)
> 1152651a (btrfs: qgroup: account shared subtrees during snapshot delete)
>

We aren't reverting these two commits, what we had was worse before than 
it is now.  We need to figure out why this is resulting in problems and 
fix that rather than throwing out a whole bunch of work.  Thanks,

Josef

