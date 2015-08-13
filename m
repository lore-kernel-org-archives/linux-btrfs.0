Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32908 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbbHMOgF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 10:36:05 -0400
Message-ID: <55CCAB4A.6010905@oracle.com>
Date: Thu, 13 Aug 2015 22:35:54 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/3] xfstests: btrfs: test device delete with EIO on
 src dev
References: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>	<1430852599-22724-1-git-send-email-anand.jain@oracle.com>	<1430852599-22724-4-git-send-email-anand.jain@oracle.com> <CAL3q7H4W663uBV=Xoc4Xs=LxQ5rzoV1hyNy-FQxO1qJDsmu6Gw@mail.gmail.com>
In-Reply-To: <CAL3q7H4W663uBV=Xoc4Xs=LxQ5rzoV1hyNy-FQxO1qJDsmu6Gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Hi Filipe,


> Any reason to not run here fsstress like the test from patch 2? Doing
> the device delete with a non-empty fs is a lot more interesting and
> can help find bugs and regressions in the future.

   You are reviewing v2. fsstress was added in v4.


>> Also this test needs the latest btrfs-progs and kernel patch
>
> Not patch, but patch set instead. I was looking for a patch with that
> title and didn't found any, only a cover letter with the subject:
> "[PATCH 0/8 v2] device delete by devid".
>
>> under title
>>    [PATCH] device delete by devid

  will update comments.

>> When this patch is not found in the btrfs-progs, this test
>> will not run. However when the require patch is not found
>> in the kernel it will fail gracefully.
>
> What's the status of these patches (both kernel and btrfs-progs)? I've
> noticed they've been around since april and no feedback on the mailing
> list.



Thanks, Anand

