Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33726 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbcHHNlx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Aug 2016 09:41:53 -0400
Received: by mail-wm0-f41.google.com with SMTP id p129so20459627wmp.0
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Aug 2016 06:41:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANhjow8an2qzrKy7fuKSr1vdgPOHfgatqhOx0vmPiChMWK4P=g@mail.gmail.com>
References: <CAK7rSWKrquTN3TbJgcri21VAfuR_wE4nC-TRDn_eGeF+8VJdRQ@mail.gmail.com>
 <CANhjow8an2qzrKy7fuKSr1vdgPOHfgatqhOx0vmPiChMWK4P=g@mail.gmail.com>
From: Karl Herler <karl.herler@gmail.com>
Date: Mon, 8 Aug 2016 16:41:31 +0300
Message-ID: <CAK7rSW+Rx_G3=0PAUfLAberQ8mQUXuLgK5Vq-+3a3w4gN3h6uQ@mail.gmail.com>
Subject: Re: Save way to migrate from raid 5/6?
To: Justin Kilpatrick <jkilpatr@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you Justin,

I successfully converted two machines running raid5 to raid10 by doing
`btrfs balance -dconvert=10 -mconvert=10 /mountpoint`. I performed a
full backup before, I also calculated the shasum of all files on the
arrays before and after the conversion and it seems I got away with no
corruption or data loss.

Br,
Karl

On Mon, Aug 8, 2016 at 2:46 PM, Justin Kilpatrick <jkilpatr@redhat.com> wrote:
> Do not run device delete, the issue is with parity and disk-failure
> recovery, manually
> incurring disk failure is a very bad idea.
>
> I would suggest running a full backup of all the files before touching
> anything and then
> an in place conversion should be fine as its just reading from
> undegraded disks and
> writing in a few format. I did the same thing converting from 5 to 1
> several months ago.
> I did end up with a couple of files I had to pull from backups as they
> where marked as
> corrupted and unrecoverable.
>
> On Sat, Aug 6, 2016 at 2:58 AM, Karl Herler <karl.herler@gmail.com> wrote:
>> Hello,
>>
>> What is the safest way to migrate an existing raid 5/6 setup, to say raid 10?
>>
>> Will simply running `btrfs filesystem balance start -dconvert=10
>> -mconvert=10` work or is it sensitive to the parity calculation issue?
>>
>> Can I `btrfs device delete` some of the drives, format them and copy
>> over the data from the raid 5/6, or will delete risk running into the
>> issue?
>>
>>
>> Best regards,
>> Karl Herler
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
