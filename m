Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36579 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbbJUSkG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 14:40:06 -0400
Received: by wicfx6 with SMTP id fx6so104290945wic.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 11:40:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN05THRdYbJYZ87s+A=q4yjTULP6_jcFtS_ke7-ZHiS5P8_E+A@mail.gmail.com>
References: <CANznX5GOKcDMFTV2E-yDdvHWWf7Sn4o0PeX3vk0CZd2xmZo9mg@mail.gmail.com>
	<CANznX5FS+sT3Pay+iLdA5TmP6NX-di3fm0K_yCHs4sac_OhndA@mail.gmail.com>
	<CAN05THRdYbJYZ87s+A=q4yjTULP6_jcFtS_ke7-ZHiS5P8_E+A@mail.gmail.com>
Date: Wed, 21 Oct 2015 20:40:05 +0200
Message-ID: <CANznX5Gf9j0-sZ_F_UzQOeoHPN4ePqcv8H_a0oWNy0Bou_Jciw@mail.gmail.com>
Subject: Re: Btrfs/RAID5 became unmountable after SATA cable fault
From: "Janos Toth F." <toth.f.janos@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am afraid the filesystem right now is really damaged regardless of
it's state upon the unexpected cable failure because I tried some
dangerous options after read-only restore/recovery methods all failed
(including zero-log, followed by init-csum-tree and even
chunk-recovery -> all of them just spit out several kind of errors
which suggested they probably didn't even write anything to the disks
before they decided that they already failed but they only caused more
harm than good if they did write something).

Actually, I almost got rid of this data myself intentionally when my
new set of drives arrived. I was considering if I should simply start
from scratch (may be reviewing and might be saving my "scratchpad"
portion of the data but nothing really irreplaceable and/or valuable)
but I thought it's a good idea to test the "device replace" function
in real life.

Even though the replace operation seemed to be successful I am
beginning to wonder if it wasn't really.


On Wed, Oct 21, 2015 at 7:42 PM, ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
> Maybe hold off erasing the drives a little in case someone wants to
> collect some extra data for diagnosing how/why the filesystem got into
> this unrecoverable state.
>
> A single device having issues should not cause the whole filesystem to
> become unrecoverable.
>
> On Wed, Oct 21, 2015 at 9:09 AM, Janos Toth F. <toth.f.janos@gmail.com> wrote:
>> I went through all the recovery options I could find (starting from
>> read-only to "extraordinarily dangerous"). Nothing seemed to work.
>>
>> A Windows based proprietary recovery software (ReclaiMe) could scratch
>> the surface but only that (it showed me the whole original folder
>> structure after a few minutes of scanning and the "preview" of some
>> some plaintext files was promising but most of the bigger files seemed
>> to be broken).
>>
>> I used this as a bulk storage for backups and all the things I didn't
>> care to keep in more than one copies but that includes my
>> "scratchpad", so I cared enough to use RAID5 mode and to try restoring
>> some things.
>>
>> Any last ideas before I "ata secure erase" and sell/repurpose the disks?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
