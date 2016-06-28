Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54820 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751999AbcF1AQZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 20:16:25 -0400
Subject: Re: [PATCH 05/14] Btrfs: warn_on for unaccounted spaces
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        <linux-btrfs@vger.kernel.org>
References: <1458926760-17563-1-git-send-email-jbacik@fb.com>
 <1458926760-17563-6-git-send-email-jbacik@fb.com>
 <d8055e61-f36f-f7d8-8963-e84532a0e31a@cn.fujitsu.com>
 <992d9eb6-a779-e104-fa84-007838e53701@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <235b2a1b-d0a9-1dd9-28b8-c35d1ae32ac2@cn.fujitsu.com>
Date: Tue, 28 Jun 2016 08:16:12 +0800
MIME-Version: 1.0
In-Reply-To: <992d9eb6-a779-e104-fa84-007838e53701@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/27/2016 09:03 PM, Chris Mason wrote:
>
>
> On 06/27/2016 12:47 AM, Qu Wenruo wrote:
>> Hi Josef,
>>
>> Would you please move this patch to the first of the patchset?
>>
>> It's making bisect quite hard, as it will always stop at this patch,
>> hard to check if it's a regression or existing bug.
>
> That's a good idea.  Which workload are you having trouble with?
>
> -chris
>
>
Qgroup test which hits EDQUOTA.

After hitting EDQUOTA, unmount will always trigger a kernel warning, for 
DATA space whose byte_may_use is not zero.

The problem is long existing, seems to be buffered write doesn't clean 
up its delalloc reserved DATA space.

Thanks,
Qu


