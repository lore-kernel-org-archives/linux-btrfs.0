Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:38023 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbbDFTvk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Apr 2015 15:51:40 -0400
Received: by igbqf9 with SMTP id qf9so27957833igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2015 12:51:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2290805.G7iFbWqiA5@term0>
References: <10997785.A11jaNpIP8@malu-aspire-v3-771>
	<CAJCQCtRLN8_Qe+0Hh0o-NCoc7KFWMu_wWbP8fObB3hq_xNgoFw@mail.gmail.com>
	<2290805.G7iFbWqiA5@term0>
Date: Mon, 6 Apr 2015 13:51:39 -0600
Message-ID: <CAJCQCtSVL-MKVczUPC+mqoWDeEOY4N3-_58_kDZwFfiJimmy1A@mail.gmail.com>
Subject: Re: recover corrupt BTRFS
From: Chris Murphy <lists@colorremedies.com>
To: Martin <develop@imagmbh.de>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 6, 2015 at 1:08 PM, Martin <develop@imagmbh.de> wrote:
> Am Montag, 6. April 2015, 09:45:10 schrieb Chris Murphy:
>> On Mon, Apr 6, 2015 at 5:40 AM, Martin <develop@imagmbh.de> wrote:
>> > Hello!
>> >
>> > I have to recover a corrupt btrfs. The size is approx 4.5 TB. The fs
>> > became
>> > corrupt by failure of a hardware-raid.
>>
>> What raid level? What kind of failure? What is the current raid
>> status? What was the mkfs.btrfs command used to create the file system
>> OR what is the current profile used for data and metadata?
>
> Hello Chris,
>
> it was a hardware-RAID (3ware-Controller), RAID-5. There was a failure of 2 of
> 6 disks. Because only one disk was physically damaged, I could "dd" the RAID
> to a new big disk with the help of 3Ware/Avago.
>
> The stack was: hardware-raid --- Linux LVM --- btrfs. The metadata-profile was
> the default for a single drive, so it should be "dup".

Small files are stored inline with metadata, so possibly those have
survived because of this.

Data profile is single and the corruption from the raid failure, or
raid failure to properly rebuild, so there's no way for Btrfs to
recover if the single copy is bad. I'd look at the raid recovery
somehow being flawed. As far as getting data off this Btrfs volume, it
sounds like a job for btrfs restore.

-- 
Chris Murphy
