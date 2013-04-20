Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913Ab3DTXso (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 19:48:44 -0400
Message-ID: <5173295D.4060503@redhat.com>
Date: Sat, 20 Apr 2013 16:48:45 -0700
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: update mkfs.btrfs help info for raid5/6
References: <1362361048-30744-1-git-send-email-zwu.kernel@gmail.com> <51732102.6080104@kingswood-consulting.co.uk>
In-Reply-To: <51732102.6080104@kingswood-consulting.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/20/13 4:13 PM, Frank A. Kingswood wrote:
> On 04/03/13 01:37, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
>>
>>    Since raid5/6 support was introduced, we should update mkfs.btrfs help info.
>>
>> Signed-off-by: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
>> ---
>>   mkfs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mkfs.c b/mkfs.c
>> index 5ece186..f9f26a5 100644
>> --- a/mkfs.c
>> +++ b/mkfs.c
>> @@ -326,7 +326,7 @@ static void print_usage(void)
>>       fprintf(stderr, "options:\n");
>>       fprintf(stderr, "\t -A --alloc-start the offset to start the FS\n");
>>       fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
>> -    fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid10, dup or single\n");
>> +    fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid5, raid6, raid10, dup or single\n");
>>       fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
>>       fprintf(stderr, "\t -L --label set a label\n");
>>       fprintf(stderr, "\t -m --metadata metadata profile, values like data profile\n");
> 
> Nitpick: that line of output is now longer than 80. Perhaps instead of "\t " have a few spaces at the start of each line.

or maybe:

+    fprintf(stderr, "\t -d --data data profile: [raid0|raid1|raid5|raid6|raid10|dup|single]\n");

I think that fits...

> Frank
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

