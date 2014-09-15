Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49950 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409AbaION5W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 09:57:22 -0400
Message-ID: <5416F03D.4030209@fb.com>
Date: Mon, 15 Sep 2014 09:57:17 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: remove empty block groups automatically
References: <1410549510-22336-1-git-send-email-jbacik@fb.com> <F9E95213-710B-42A2-A904-3EE1CE95B72E@gmail.com>
In-Reply-To: <F9E95213-710B-42A2-A904-3EE1CE95B72E@gmail.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/14/2014 12:46 AM, Wang Shilong wrote:
> Hi Josef,
>
>> One problem that has plagued us is that a user will use up all of his space with
>> data, remove a bunch of that data, and then try to create a bunch of small files
>> and run out of space.  This happens because all the chunks were allocated for
>> data since the metadata requirements were so low.  But now there's a bunch of
>> empty data block groups and not enough metadata space to do anything.  This
>> patch solves this problem by automatically deleting empty block groups.  If we
>> notice the used count go down to 0 when deleting or on mount notice that a block
>> group has a used count of 0 then we will queue it to be deleted.
>>
>> When the cleaner thread runs we will double check to make sure the block group
>> is still empty and then we will delete it.  This patch has the side effect of no
>> longer having a bunch of BUG_ON()'s in the chunk delete code, which will be
>> helpful for both this and relocate.  Thanks,
>
> I am wondering whether we could check if it a Mixed Mode, we don¡¯t need remove
> Mixed mode block groups automatically¡­

Good point, I'll update the patch.  Thanks,

Josef

