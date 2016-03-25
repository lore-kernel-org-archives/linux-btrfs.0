Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35486 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbcCYOnO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 10:43:14 -0400
Received: by mail-lb0-f172.google.com with SMTP id bc4so49453141lbc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 07:43:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAO5K3Od8Xi9KAae9gMCWzm4LHxW9mOBU9UPEB7kVqu6uyJ=j9Q@mail.gmail.com>
References: <CAO5K3OeqQUx18gjHNVcOK8=Zo=JLOJhHBJz4jdti73DGakeAfQ@mail.gmail.com>
	<CAGGqMYRRprO_x51A5ZX4ABKcS6_LyTWgf=meZE+aAX990kAJEw@mail.gmail.com>
	<CAO5K3Od8Xi9KAae9gMCWzm4LHxW9mOBU9UPEB7kVqu6uyJ=j9Q@mail.gmail.com>
Date: Fri, 25 Mar 2016 15:43:12 +0100
Message-ID: <CAGGqMYRWhJwzY5V5wgwi+RCa2A=_bG9iorAF6dP9zC8cRg-6oQ@mail.gmail.com>
Subject: Re: btrfs ways to travel back in time
From: Alexander Fougner <fougner89@gmail.com>
To: Vytautas D <vytdau@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-03-23 23:31 GMT+01:00 Vytautas D <vytdau@gmail.com>:
>
>> atime). Also, this might break some configurations not expecting the
>> set-default method
>
> I have never seen this before. Can you extend on this or provide a link so i
> can read more about such limitation?
>>

Ubuntu, for instance. Layout as /@ for root FS and /@home for /home.
Set-default will break this.

>> >  2. reboot
>> > b) always mount into snapshot
>> >  1. mount -o suvol=/.current $disk # at initrd
>> >  2. btrfs subvol del /.current
>> >  3. btrfs subvol snapshot /.snapshotA /.current
>> >  4. reboot
>> > c) rsync
>> >  1. rsync $options /.snapshotA /.current
>> >  2. reboot
>>
>> Depending on how broken the setup is, I'd probably go for the btrfs
>> sub snap ./__snapshots/@oldsnap ./@current approach.
> Is there a technical reason behind this ?
>

I'm not sure I understand what "this" refers to, but another way to do
it would be to just move the snap and set it as rw. But that consumes
the snapshot for further use.


>> If it is very broken (as in not bootable), then a temporary boot into
>> a readonly snapshot might be required. This is quite easy to do in
>> the grub menu, changing the boot parameter. I've also heard of
>> symlinking to the actual subvolume you want to use, and resymlink it
>> when an older snapshot is desired.
>
> Just to make it clear, i don't have broken system and have full control. I
> am interested in strategies and reasoning.

What I meant was that there are different levels of "breaking".
Depending on how bad the failure is, a rollback on the live FS might
be sufficient.

mv @ @broken
btrfs sub snap __snap/@_$date @
reboot

>>
>> >
>> > - Vytas Dauksa
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>> > in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
