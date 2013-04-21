Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:41088 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab3DUJgg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Apr 2013 05:36:36 -0400
Received: by mail-qc0-f173.google.com with SMTP id b12so2738095qca.4
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Apr 2013 02:36:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEH94Lg2b9uYk=+cf_KXKnFYnMxPBM_rKGJairX14TtvGHD=ww@mail.gmail.com>
References: <1362361048-30744-1-git-send-email-zwu.kernel@gmail.com>
	<51732102.6080104@kingswood-consulting.co.uk>
	<5173295D.4060503@redhat.com>
	<CAEH94Lg2b9uYk=+cf_KXKnFYnMxPBM_rKGJairX14TtvGHD=ww@mail.gmail.com>
Date: Sun, 21 Apr 2013 17:36:35 +0800
Message-ID: <CAEH94LgUiOK9Q6FMrwT7PM9v3Rbo6F5FQdrcR1Q7xRm1HQ3QeQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: update mkfs.btrfs help info for raid5/6
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I found this patch had been merged into David's unstable btrfs-progs
git, but not into its master git, so don't know the reason. If it need
me to send v2 based on your comments, please let me know, thanks.

On Sun, Apr 21, 2013 at 5:33 PM, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
> I found this patch had been merged into David's unstable btrfs-progs git,
> but not into its master git, so don't know the reason. If it need me to send
> v2 based on your comments, please let me know, thanks.
>
>
>
> On Sun, Apr 21, 2013 at 7:48 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>>
>> On 4/20/13 4:13 PM, Frank A. Kingswood wrote:
>> > On 04/03/13 01:37, zwu.kernel@gmail.com wrote:
>> >> From: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
>> >>
>> >>    Since raid5/6 support was introduced, we should update mkfs.btrfs
>> >> help info.
>> >>
>> >> Signed-off-by: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
>> >> ---
>> >>   mkfs.c | 2 +-
>> >>   1 file changed, 1 insertion(+), 1 deletion(-)
>> >>
>> >> diff --git a/mkfs.c b/mkfs.c
>> >> index 5ece186..f9f26a5 100644
>> >> --- a/mkfs.c
>> >> +++ b/mkfs.c
>> >> @@ -326,7 +326,7 @@ static void print_usage(void)
>> >>       fprintf(stderr, "options:\n");
>> >>       fprintf(stderr, "\t -A --alloc-start the offset to start the
>> >> FS\n");
>> >>       fprintf(stderr, "\t -b --byte-count total number of bytes in the
>> >> FS\n");
>> >> -    fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid10,
>> >> dup or single\n");
>> >> +    fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid5,
>> >> raid6, raid10, dup or single\n");
>> >>       fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
>> >>       fprintf(stderr, "\t -L --label set a label\n");
>> >>       fprintf(stderr, "\t -m --metadata metadata profile, values like
>> >> data profile\n");
>> >
>> > Nitpick: that line of output is now longer than 80. Perhaps instead of
>> > "\t " have a few spaces at the start of each line.
>>
>> or maybe:
>>
>> +    fprintf(stderr, "\t -d --data data profile:
>> [raid0|raid1|raid5|raid6|raid10|dup|single]\n");
>>
>> I think that fits...
>>
>> > Frank
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>> > in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>
> --
> Regards,
>
> Zhi Yong Wu



-- 
Regards,

Zhi Yong Wu
