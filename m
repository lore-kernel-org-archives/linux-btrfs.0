Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44315 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751761AbeACN6G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jan 2018 08:58:06 -0500
Subject: Re: [PATCH] btrfs: not a disk error if the bio_add_page fails
To: fdmanana@gmail.com
Cc: linux-btrfs@vger.kernel.org
References: <20180103080729.20804-1-anand.jain@oracle.com>
 <CAL3q7H7DG_J3zgKurZB+ba7GxiW4_EUTh2i_3a54iRecruNixA@mail.gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ceffe3f0-0691-03a7-f954-ad23386307cb@oracle.com>
Date: Wed, 3 Jan 2018 21:53:53 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7DG_J3zgKurZB+ba7GxiW4_EUTh2i_3a54iRecruNixA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/03/2018 07:34 PM, Filipe Manana wrote:
> On Wed, Jan 3, 2018 at 8:07 AM, Anand Jain <anand.jain@oracle.com> wrote:
>> bio_add_page() can fail for logical reasons as from the bio_add_page()
>> comments:- 'This will only fail if either
>> bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.' Don't inc the
>> write error statistics for this. And set -EINVAL instead of -EIO.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/scrub.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>> index d766c73eb29a..8c1508a41f90 100644
>> --- a/fs/btrfs/scrub.c
>> +++ b/fs/btrfs/scrub.c
>> @@ -4618,15 +4618,15 @@ static int write_page_nocow(struct scrub_ctx *sctx,
>>          bio->bi_opf = REQ_OP_WRITE | REQ_SYNC;
>>          ret = bio_add_page(bio, page, PAGE_SIZE, 0);
>>          if (ret != PAGE_SIZE) {
>> -leave_with_eio:
>>                  bio_put(bio);
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (btrfsic_submit_bio_wait(bio)) {
>>                  btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
>>                  return -EIO;
>>          }
> 
> You are now introducing a leak of the bio. Missing bio_put(bio) before
> returning.

  Oops. My bad. Thanks. Now fixed in v2.

- Anand

>>
>> -       if (btrfsic_submit_bio_wait(bio))
>> -               goto leave_with_eio;
>> -
>>          bio_put(bio);
>>          return 0;
>>   }
>> --
>> 2.15.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
