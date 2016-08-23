Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14997 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752476AbcHWIbr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 04:31:47 -0400
Subject: Re: [dm-devel] [Regression/Behavior change]dm-flakey corrupt read
 bio, even the feature is drop_writes
To: Lukas Herbolt <lherbolt@redhat.com>
References: <cc2b06b5-7598-67ab-d528-9087cbf75f45@cn.fujitsu.com>
 <CAM4Jq_4t0uGMA2KtGJWgM36wyu7czWjZQD0Lchh6n=gGZ9F+WQ@mail.gmail.com>
 <CAM4Jq_424FJSogLYj5gcf_JsQTF8U8UjdpCbs_vpqjCtqFqXXw@mail.gmail.com>
CC: Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <c66a14e2-0c62-bf1c-bcf6-9567d5cc87ba@cn.fujitsu.com>
Date: Tue, 23 Aug 2016 16:30:29 +0800
MIME-Version: 1.0
In-Reply-To: <CAM4Jq_424FJSogLYj5gcf_JsQTF8U8UjdpCbs_vpqjCtqFqXXw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Lukas,

Thanks for your patch, while I am a little concerned of it, even I'm a 
newbie to flakey code.

At 08/22/2016 10:53 PM, Lukas Herbolt wrote:
> Hi Qu,
>
> Sorry for the confusion. Reading the email again and the code it seems
> that the READS are really returned as -EIO if you set the drop_writes.
> I just tested it and you are right.
>
> If I was reading the fstest correctly the flakey is created as:
> ---
> flakey: 0 409600 flakey 8:64 0 0 180 1 drop_writes
> ---
>
> I believe the READs are dropped because it does not have any flags set.
>
> ---
>         if (bio_data_dir(bio) == READ) {
>             /* If flags were specified, only corrupt those that match. */
>             if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == READ) &&
>                 all_corrupt_bio_flags_match(bio, fc))
>                 goto map_bio;
>             else
>                 return -EIO;
>         }
> ---
>
> with conclusion of setting:
> ---
>                 /*
>                  * Flag this bio as submitted while down.
>                  */
>                 pb->bio_submitted = true;
> ---
>
> I have quick test patch ready, but it probably broke more thing than
> fixes so I will continue on it.
> Just in case you want to test it. Diff is done again 4.8-rc1
>
> --- a/drivers/md/dm-flakey.c
> +++ b/drivers/md/dm-flakey.c
> @@ -292,6 +292,11 @@ static int flakey_map(struct dm_target *ti,
> struct bio *bio)
>                  * Map reads as normal only if corrupt_bio_byte set.
>                  */
>                 if (bio_data_dir(bio) == READ) {
> +                        /* We should retunr all READS as ok in case
> of DROP WRITES flag is set. */
> +                       if (test_bit(DROP_WRITES, &fc->flags)) {
> +                               pb->bio_submitted = false;
> +                               goto map_bio;
> +                       }

According to my personal understanding, drop_writes should:
1) Drop any write bio silently
    Just as its name
2) For read
2.1) Read out data if the range doesn't include corrupt_bio_byte

2.2) Read out corrupted data if the range contains corrupt_bio_byte.

So it seems that 2.2) is not fulfilled.

While it solves the problem I reported, I'm still concerned if it 
matches the correct/designed behavior of flakey.

Thanks,
Qu
>                         /* If flags were specified, only corrupt those
> that match. */
>                         if (fc->corrupt_bio_byte &&
> (fc->corrupt_bio_rw == READ) &&
>                             all_corrupt_bio_flags_match(bio, fc))
>
>
>
> On Mon, Aug 22, 2016 at 10:05 AM, Lukas Herbolt <lherbolt@redhat.com> wrote:
>> Hello,
>>
>> There is patch from Mike. It's part of current pull request to 4.8-rc1
>> For more details check:
>>  - https://www.redhat.com/archives/dm-devel/2016-July/msg00561.html
>>  - https://www.redhat.com/archives/dm-devel/2016-August/msg00109.html
>>
>> Lukas
>>
>> On Mon, Aug 22, 2016 at 9:31 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>> Hi, Mike and btrfs and dm guys
>>>
>>> When doing regression test on v4.8-rc1, we found that fstests/btrfs/056
>>> always fails. With the following dmesg:
>>> ---
>>> Buffer I/O error on dev dm-0, logical block 1310704, async page read
>>> Buffer I/O error on dev dm-0, logical block 16, async page read
>>> Buffer I/O error on dev dm-0, logical block 16, async page read
>>> ---
>>>
>>> And bisect leads to the following commits:
>>> ---
>>> commit 99f3c90d0d85708e7401a81ce3314e50bf7f2819
>>> Author: Mike Snitzer <snitzer@redhat.com>
>>> Date:   Fri Jul 29 13:19:55 2016 -0400
>>>
>>>     dm flakey: error READ bios during the down_interval
>>> ---
>>>
>>> While according to the document of dm-flakey, it says that when using
>>> drop_writes feature, read bios are not affected:
>>> ---
>>>   drop_writes:
>>>         All write I/O is silently ignored.
>>>         Read I/O is handled correctly.
>>> ---
>>>
>>> If I understand the word "correctly" correctly, it should means READ I/0 is
>>> handled without problem.
>>>
>>> However with this commit, it also corrupt the read bio, leading to the test
>>> failure.
>>>
>>>
>>> At least there are two fixes available here;
>>> 1) Fix fstest scripts
>>>    The related macro is "_flakey_drop_and_remount yes", which will
>>>    check the fs during the "drop_writes" time.
>>>
>>>    Currently, only btrfs/056 calls "_flakey_drop_and_remount" with
>>>    "yes". So other test cases are not affected.
>>>
>>>    However, even we move the fsck outside of the "drop_writes" range,
>>>    although test case can pass without problem, but we will still
>>>    get a dmesg error:
>>>    "Buffer I/O error on dev dm-0, logical block 1310704, async page read"
>>>
>>> 2) Revert to flakey behavior to allow READ bio
>>>    Then everything is back to the old good days.
>>>
>>> Not sure which one is correct for current use case, as I'm not familiar with
>>> dm codes.
>>>
>>> Any idea to fix dm-flaky and keep the READ bio behavior?
>>>
>>> Thanks,
>>> Qu
>>>
>>>
>>>
>>>
>>>
>>> --
>>> dm-devel mailing list
>>> dm-devel@redhat.com
>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>>
>>
>> --
>> Lukas Herbolt
>> RHCE, RH436, BSc, SSc
>> Senior Technical Support Engineer
>> Global Support Services (GSS)
>> Email:    lherbolt@redhat.com
>
>
>


