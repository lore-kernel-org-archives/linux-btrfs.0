Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:45814 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932203AbeF1IQ0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 04:16:26 -0400
Received: by mail-qk0-f169.google.com with SMTP id c198-v6so2498625qkg.12
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 01:16:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <fb26f3cc-fa80-222e-e403-0eead6f5e575@gmx.com>
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com> <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
 <4852d583-4bdb-bb43-76a3-d14c9ef3f66e@gmx.com> <1530155643.1842027.1422969944.6697CF24@webmail.messagingengine.com>
 <fb26f3cc-fa80-222e-e403-0eead6f5e575@gmx.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Thu, 28 Jun 2018 11:16:24 +0300
Message-ID: <CAA91j0VTewHifyxBisMgiOw0ufmSWM7m-Cm4=5d0DP4kppSK6w@mail.gmail.com>
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: remi@georgianit.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 28, 2018 at 8:39 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年06月28日 11:14, remi@georgianit.com wrote:
>>
>>
>> On Wed, Jun 27, 2018, at 10:55 PM, Qu Wenruo wrote:
>>
>>>
>>> Please get yourself clear of what other raid1 is doing.
>>
>> A drive failure, where the drive is still there when the computer reboots, is a situation that *any* raid 1, (or for that matter, raid 5, raid 6, anything but raid 0) will recover from perfectly without raising a sweat. Some will rebuild the array automatically,
>
> WOW, that's black magic, at least for RAID1.
> The whole RAID1 has no idea of which copy is correct unlike btrfs who
> has datasum.
>
> Don't bother other things, just tell me how to determine which one is
> correct?
>

When one drive fails, it is recorded in meta-data on remaining drives;
probably configuration generation number is increased. Next time drive
with older generation is not incorporated. Hardware controllers also
keep this information in NVRAM and so do not even depend on scanning
of other disks.

> The only possibility is that, the misbehaved device missed several super
> block update so we have a chance to detect it's out-of-date.
> But that's not always working.
>

Why it should not work as long as any write to array is suspended
until superblock on remaining devices is updated?

> If you're talking about missing generation check for btrfs, that's
> valid, but it's far from a "major design flaw", as there are a lot of
> cases where other RAID1 (mdraid or LVM mirrored) can also be affected
> (the brain-split case).
>

That's different. Yes, with software-based raid there is usually no
way to detect outdated copy if no other copies are present. Having
older valid data is still very different from corrupting newer data.

>> others will automatically kick out the misbehaving drive.  *none* of them will take back the the drive with old data and start commingling that data with good copy.)\ This behaviour from BTRFS is completely abnormal.. and defeats even the most basic expectations of RAID.
>
> RAID1 can only tolerate 1 missing device, it has nothing to do with
> error detection.
> And it's impossible to detect such case without extra help.
>
> Your expectation is completely wrong.
>

Well ... somehow it is my experience as well ... :)

>>
>> I'm not the one who has to clear his expectations here.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
