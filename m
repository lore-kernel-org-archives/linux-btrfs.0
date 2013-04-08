Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:44569 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934715Ab3DHK7y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2013 06:59:54 -0400
Received: by mail-la0-f44.google.com with SMTP id fr10so2136632lab.17
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Apr 2013 03:59:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFWF=amKDGqWzXegx456jByctj0z5DOco1dNpMd42xnDiwQuHA@mail.gmail.com>
References: <CAFWF=ameE9p4W5XT-yLoU2H=by0Y4yp3VUmiLOXSOtOzBHaYwQ@mail.gmail.com>
 <CAFWF=amKDGqWzXegx456jByctj0z5DOco1dNpMd42xnDiwQuHA@mail.gmail.com>
From: Harald Glatt <mail@hachre.de>
Date: Mon, 8 Apr 2013 12:59:31 +0200
Message-ID: <CAFWF=akP_UowfTdmtgS6uG87OwK=PMpoc_RgEqBw5WdT-a+9Lw@mail.gmail.com>
Subject: Re: btrfs can't complete balance
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 8, 2013 at 10:45 AM, Harald Glatt <mail@hachre.de> wrote:
> The dmesg from the kernel panic can be seen here:
> http://pastebin.com/3QZqrqAX
>
> I've tried to create a btrfs-image but I'm getting a crash of the
> utility after only 50 MB...
>
> Check tree block failed, want=320304799744, have=0
> Check tree block failed, want=320305049600, have=0
> Check tree block failed, want=320298184704, have=0
> Check tree block failed, want=320298184704, have=0
> Check tree block failed, want=320305221632, have=0
> Check tree block failed, want=320308678656, have=0
> Check tree block failed, want=320308678656, have=0
> Check tree block failed, want=320297295872, have=0
> Check tree block failed, want=320297295872, have=0
> Check tree block failed, want=320297295872, have=721320548710005777
> Check tree block failed, want=320297295872, have=721320548710005777
> Check tree block failed, want=320297295872, have=721320548710005777
> read block failed check_tree_block
> btrfs-image: btrfs-image.c:518: create_metadump: Assertion `!(ret < 0)' failed.
> [1]    32513 abort (core dumped)
>
>
> On Mon, Apr 8, 2013 at 9:48 AM, Harald Glatt <mail@hachre.de> wrote:
>> Hi all,
>>
>> I've managed to ruin my btrfs filesystem, but I don't know how. I
>> basically have it split up into two subvolumes, one for the root and
>> one for home both of which are creating hourly snapshots.
>>
>> I've 'btrfs send' some of those to an external machine every now and
>> then. (At least once a day)
>>
>> At some point 'btrfs send' stopped working but gave no better error
>> message than invalid argument.
>>
>> I did a balance on the drive which resulted in a kernel panic after a
>> while of working. It then repeated the balance automatically on the
>> next bootup until it finally said 'balance failed' when I checked with
>> btrfs fi balance status.
>>
>> I'm running a funky setup here where two partitions on the same drive
>> are both added into the same btrfs volume resulting in this setup:
>>
>> Label: none  uuid: 4e74fa05-4bf2-40da-946b-8cd53ce92242
>> Total devices 2 FS bytes used 54.60GB
>> devid    1 size 60.52GB used 52.04GB path /dev/sda7
>> devid    2 size 16.32GB used 8.03GB path /dev/sda5
>>
>> Data: total=54.00GB, used=53.51GB
>> System, RAID1: total=32.00MB, used=12.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, RAID1: total=3.00GB, used=1.11GB
>>
>> The state that I'm in is that everything is working, I haven't found
>> any data corruption, scrubs work and confirm that there are no errors
>> but I can no longer use 'btrfs send' to create differential images and
>> I can also no longer complete a balance.
>>
>> I tried running balance start -dconvert=single to get rid of my second
>> partition but that also failed (without a panic though)
>>
>> I have backed up the newest state of the filesystem via rsync and am
>> about to wipe and restore from backup with a new fs.
>>
>> Is anyone interested in a btrfs-image to debug this state? If so
>> please tell me what command to run since I have never done this
>> before...
>>
>> Thanks
>> Harald

I didn't realize it had to be unmounted for the image. I've uploaded a
successful image with -c9. I'll give out the URL on demand.

However there are news: I managed after creating that image to
successfully balance down to single and remove the second drive. I
readded it again and now everything is back to normal and working...
It is possible that after that kernel panic it indeed finished the
balance correctly and I misread the error message saying something
along the lines of 'error while getting status: balance not in
progress' for something that was telling me the balance failed...

Ultimately that reduces this issue down to, something caused 'btrfs
send' to fail, a balance then kernel paniced and afterwards everything
was back to normal. I don't think the image that I have will be of any
help because that imagine is of course from after that kernel panic
and I suppose completeling that balance then fixed the issues - even
if it paniced along the way.

Thanks
Harald
