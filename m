Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41821 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751745AbaE3A5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 20:57:18 -0400
Message-ID: <5387D7AA.3040000@cn.fujitsu.com>
Date: Fri, 30 May 2014 08:58:18 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Add dev uuid output for print_dev_item().
References: <1401325356-27683-1-git-send-email-quwenruo@cn.fujitsu.com> <CAMU1PDhBuk46VgwNVnO_1JzOgZka1wd8dMvTjECwTRBsfZeghQ@mail.gmail.com>
In-Reply-To: <CAMU1PDhBuk46VgwNVnO_1JzOgZka1wd8dMvTjECwTRBsfZeghQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs-progs: Add dev uuid output for print_dev_item().
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年05月30日 03:52
> On 29 May 2014 02:02, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> The original print_dev_item() only prints device id,total bytes and
>> bytes used.
>> When it comes to debug things related to duplicated device id, dev uuid
>> is needed to distinguish different device since device is is no
>> reliable.
> At the end of the message I think there is a couple of typos and you meant:
> ... device id is not reliable.
Yes, it is not reliable when comes to reappered missing devices.
If you mounted btrfs with missing device using degraded mode and 
replaced missing device,
but the missing device reappered, then devices with same dev uuid will 
show up.

Thanks,
Qu
>
>> This patch added dev uuid output.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>   print-tree.c | 13 +++++++++++--
>>   1 file changed, 11 insertions(+), 2 deletions(-)
> Thanks,
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

