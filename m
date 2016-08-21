Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35067 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751222AbcHUAgY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Aug 2016 20:36:24 -0400
Received: by mail-oi0-f45.google.com with SMTP id 4so109541374oih.2
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Aug 2016 17:36:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BLU437-SMTP168169D258F02597287B2E92170@phx.gbl>
References: <CAMPo9spd+GF18K7sDZDsfvqLQJYwt_YuYM_05KOnVFmw_Vsrhw@mail.gmail.com>
 <CAJCQCtTQAG+0M9AsNj5LNWXTAKd8V-6DL=5kS80dPt59S1uiAA@mail.gmail.com> <BLU437-SMTP168169D258F02597287B2E92170@phx.gbl>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 20 Aug 2016 18:36:21 -0600
Message-ID: <CAJCQCtS1LPmYN2JY0cayWpCPVzaPq+KQSZZU4g9ifVGT9HCZCg@mail.gmail.com>
Subject: Re: Mixing partitioned and non-partitioned discs in a RAID?
To: Alberto Bursi <alberto.bursi@outlook.it>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 20, 2016 at 1:38 PM, Alberto Bursi <alberto.bursi@outlook.it> wrote:
>
>
> On 08/20/2016 05:21 PM, Chris Murphy wrote:
>>
>> On Fri, Aug 19, 2016 at 10:00 PM, Bearcat Şándor
>> <bearcatsandor@gmail.com> wrote:
>>>
>>> I have a btrfs non-raid file system that i'd like to convert to
>>> raid10. This single device has my efi boot partion on it, so it's
>>> partitioned into sda1 and sda2. I have 3 other discs (sdc-sde) that
>>> i'd like to make partition-less systems and then add them to the first
>>> disc (sda) using the steps in the conversion section of the wiki
>>>
>>> (https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Conversion).
>>>
>>> My concern in that i'll be mixing a partitioned and partition-less
>>> system.  Will that work or will i hose myself?
>>
>> That will work, but you'll likely be in a hosed situation later should
>> you ever lose a drive so I don't recommend this layout.
>>
>> a. You have the ESP on only one drive, so it's still a single point of
>> failure. If that drive dies you can't boot. There are various ways
>> around that but they all pretty much suck right now from an end user
>> perspective. Basically redundant boot on UEFI with Linux right now is
>> pretty much shit. You have to be a bootloader expert to set it up,
>> maintain it with software updates, and fix it should things go bad.
>
> The usual solution to this is keeping the ESP on a separate (small) flash
> drive.

It's a good idea. It'd be nice if installers offered to put the ESP on
non-boot USB (so it's not overwriting the installer media).



> I still vehemently hate the fact that they couldn't provide like 2 MB of
> space on an onboard NOR flash chip to store a bootloader. Seriously, rEFInd
> with filesystem drivers to boot off btrfs and ext and whatever needs like
> 1.5 MB.


Needs to be bigger. The secure boot stuff takes up more room than
this, about 6-8MiB depending on the distro. And then more room needed
for dual booting let alone triple, which of course no manufacturer
really cares about.


> But no, they need to make a stupid system that is hardcoded to a disk, and
> to a crappy filesystem.

Ahh well the onboard flash could just appear as a small SATA or sdcard
or USB mass storage devices, whatever's easiest to implement.

FAT leaves a lot to be desired but it's pretty universally supported
and almost trivial to repair *if* the volume is repairable in the
first place. The much bigger issue with ESP on Linux is this neurotic
tendency of distros to persistently mount shit that does not need to
be mounted. Like the ESP, and even the dedicated boot volume. They
only need to be mounted when being updated and then should be
umounted. And worse the convention is to do nested mount with /boot
and then /boot/efi for the ESP so it's twice as bad a practice. By
virtue of mounting the ESP the dirty bit is set, so any crash means it
must be fsck'd and if that doesn't work, it's game over for that
volume. Fragile setup.

-- 
Chris Murphy
