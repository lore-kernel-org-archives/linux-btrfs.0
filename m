Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34358 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbcCXLQY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 07:16:24 -0400
Subject: Re: [PATCH] fstest: btrfs: update 048.out inline with ui changes
To: Eryu Guan <eguan@redhat.com>
References: <1458814272-5783-1-git-send-email-anand.jain@oracle.com>
 <20160324111331.GT11419@eguan.usersys.redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56F3CC7E.50702@oracle.com>
Date: Thu, 24 Mar 2016 19:16:14 +0800
MIME-Version: 1.0
In-Reply-To: <20160324111331.GT11419@eguan.usersys.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





On 03/24/2016 07:13 PM, Eryu Guan wrote:
> On Thu, Mar 24, 2016 at 06:11:12PM +0800, Anand Jain wrote:
>> To be inline with progs changes
>>    28831d54895443e5fc795392f23ce3a8b122cb71
>>    btrfs-progs: cmd property: switch to common error message wrapper
>> update 048.out
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   tests/btrfs/048.out | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tests/btrfs/048.out b/tests/btrfs/048.out
>> index 0b20d0b5976c..1d3ccef8e870 100644
>> --- a/tests/btrfs/048.out
>> +++ b/tests/btrfs/048.out
>> @@ -9,7 +9,7 @@ label=foobar
>>   ***
>>   label=
>>   ***
>> -ERROR: object is not compatible with property
>> +ERROR: object is not compatible with property: label
>
> This fails test with old btrfs-progs. I think a filter can be added to
> btrfs/048 to filter out the ": label" part, so that test passes with
> both old and new btrfs-progs.

  Thanks.  Yep. I shall do that.



