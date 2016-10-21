Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:36098 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754732AbcJUWNW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Oct 2016 18:13:22 -0400
Received: by mail-lf0-f51.google.com with SMTP id b75so155385520lfg.3
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Oct 2016 15:13:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161021220726.GC16645@carfax.org.uk>
References: <CA+WRLO-XY2aai7z8436yna14cjbRsPrWgHwxbcf5Kq_-7RENCQ@mail.gmail.com>
 <20161021220726.GC16645@carfax.org.uk>
From: Peter Becker <floyd.net@gmail.com>
Date: Sat, 22 Oct 2016 00:13:20 +0200
Message-ID: <CAEtw4r3H52Uazt_eq+wA4bLzW88mX4=7SgKoMrOTBOJV9etE-w@mail.gmail.com>
Subject: Re: Drive Replacement
To: Hugo Mills <hugo@carfax.org.uk>, Gareth Pye <gareth@cerberos.id.au>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

if you have >750 GB free you can simply remove one of the drives.

btrfs device delete /dev/sd[x] /mnt
#power off, replace device
btrfs device add /dev/sd[y] /mnt

if not you can use an USB-SATA adapter or an eSata-Port and make the following:

btrfs device add /dev/sd[y] /mnt
btrfs device delete /dev/sd[x] /mnt
#power off, replace device

i avoid "btrfs device replace" because it's slower then add+delete

and don't forget to update fstab !

2016-10-22 0:07 GMT+02:00 Hugo Mills <hugo@carfax.org.uk>:
> On Sat, Oct 22, 2016 at 09:03:16AM +1100, Gareth Pye wrote:
>> I've got a BTRFS array that is of mixed size disks:
>> 2x750G
>> 3x1.5T
>> 3x3T
>> And it's getting fuller than I'd like. The problem is that adding
>> disks is harder than one would like as the computer only has 8 sata
>> ports. Is it viable to do the following to upgrade one of the disks?
>>
>> A) Take array offline
>> B) DD the contents of one of the 750G drives to a new 3T drive
>> C) Remove the 750G from the system
>> D) btrfs scan
>> E) Mount array
>> F) Run a balance
>>
>> I know that not physically removing the old copy of the drive will
>> cause massive issues, but if I do that everything should be fine
>> right?
>
>    Yes. The one thing missing here is running
>
> # btrfs dev resize <devid>:max /mountpoint
>
> on the new device between steps E and F to allow the FS to use the
> full amount of the device. Otherwise, it'll still be the same size as
> the original.
>
>    Hugo.
>
> --
> Hugo Mills             | Great films about cricket: Batsman Begins
> hugo@... carfax.org.uk | starring Christian Bail
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |
