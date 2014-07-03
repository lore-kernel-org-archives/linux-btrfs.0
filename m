Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20481 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaGCRc2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 13:32:28 -0400
Message-ID: <53B5939B.2050808@oracle.com>
Date: Fri, 04 Jul 2014 01:32:11 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: Miao Xie <miaox@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix wrong uevent target
References: <1404291834-11113-1-git-send-email-miaox@cn.fujitsu.com> <53B539CE.7070201@cn.fujitsu.com> <53B56211.4060403@fb.com>
In-Reply-To: <53B56211.4060403@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

   This fix is theoretically correct but my guess that this would
   solve problem as reported by Qu Wenruo was wrong [1].
   Patch is good to integrate.

Thanks, Anand

[1] Re: [PATCH RFC] btrfs: Add ctime/mtime update for btrfs device 
add/remove.


On 03/07/2014 22:00, Chris Mason wrote:
> On 07/03/2014 07:09 AM, Miao Xie wrote:
>> CC Anand Jain
>>
>> Sorry, please ignore this patch.
>> Anand wrote the same patch several days ago, so this bug fix belongs to Anand
>> though he NACKed his patch at that time.
>
> It certainly looks right, but Anand had mentioned that he had a few
> questions on testing.  I've pulled it out for now, but I'll take Anand's
> version when you're both happy.
>
> -chris
