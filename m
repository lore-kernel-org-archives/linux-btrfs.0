Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35150 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbcCUEfI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 00:35:08 -0400
Received: by mail-wm0-f44.google.com with SMTP id l68so94841553wml.0
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Mar 2016 21:35:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ=_iE3m6P-jH1VjzycBXXRv5QZUS2SPNeH7ZJ_ukWM-A@mail.gmail.com>
References: <CAC7HdqknOJAK+FcE53xO38G__gc42GR0GQW+chbGbDxXBt7HFA@mail.gmail.com>
 <CAJCQCtQ=_iE3m6P-jH1VjzycBXXRv5QZUS2SPNeH7ZJ_ukWM-A@mail.gmail.com>
From: Ryan Erato <rerato@gmail.com>
Date: Sun, 20 Mar 2016 21:34:47 -0700
Message-ID: <CAC7HdqmzhHwJFgpDAjwF9gjL_+vEm7A8sBBsGwQEmTE_BGoeqQ@mail.gmail.com>
Subject: Re: moving btrfs subvolumes to new disk
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here's an example of what I've been trying:

" mount new ssd
root / # mount /dev/sdb6 /mnt/ssd/

" snapshot ROOT sub-volume mounted at /
root / # btrfs subvol snapshot -r / /ROOT.snap
Create a readonly snapshot of '/' in '//ROOT.snap'

root / # btrfs filesystem sync /
FSSync '/'

root / # btrfs subvol list /
ID 257 gen 747906 top level 5 path ROOT
ID 258 gen 747906 top level 257 path home
ID 487 gen 747893 top level 257 path ROOT.snap

root / # btrfs send /ROOT.snap/ | btrfs receive /mnt/ssd/
At subvol /ROOT.snap/
At subvol ROOT.snap

" snapshot home subvolume at /home
root / # btrfs subvol snapshot -r /home/ /home/home.snap
Create a readonly snapshot of '/home/' in '/home/home.snap'

root / # btrfs filesystem sync /home
FSSync '/home'

root / # btrfs subvol list /
ID 257 gen 747944 top level 5 path ROOT
ID 258 gen 747944 top level 257 path home
ID 487 gen 747893 top level 257 path ROOT.snap
ID 488 gen 747942 top level 258 path home/home.snap

root / # btrfs send /home/home.snap/ | btrfs receive /mnt/ssd/
At subvol /home/home.snap/
At subvol home.snap
ERROR: send ioctl failed with -2: No such file or directory
ERROR: unexpected EOF in stream.

root / # btrfs subvol list /mnt/ssd/
ID 257 gen 57 top level 5 path ROOT.snap
ID 285 gen 62 top level 5 path home.snap

I have also attempted to mount /dev/sdb6 with mount option
"subvol=ROOT" like I do in my system fstab for the current drive. I
have also tried saving the snapshot in "/" and "/home", with the same
results.

Sending "home.snap" to "/mnt/ssd" results in the -2 error. What is
peculiar, or possibly a red herring, is that it seems to fail at the
same point each time, at 4.39GB in to the transfer. Using verbose
output on receive it seems to process the files in the same order as
again, I see the same set of files just before it fails each and every
time.

I setup my system according to gentoo documentation, so I'm not sure
if I did something wrong with the initial btrfs partition setup that
is making this more difficult.


On Sun, Mar 20, 2016 at 12:31 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sat, Mar 19, 2016 at 4:58 PM, Ryan Erato <rerato@gmail.com> wrote:
>> I'm having quite the time trying to move my current Gentoo install to
>> an SSD. I first attempted Clonezilla, but that failed while cloning
>> the btrfs partition. I then realized I could use btrfs send/receive.
>>
>> The partition has 2 subvolumes ROOT and ROOT/home. ROOT snapshots and
>> sends without hitch, but /home consistently errors at the same point
>> (from -vv output on btrfs send). btrfs send returns -2, no such file
>> or directory, unexpected EOF in stream.
>
> What's the exact command you're using for btrfs send receive for ROOT and home?
>
>
>>
>> # cat /etc/fstab
>> /dev/sda4 /boot vfat noauto,noatime 1 2
>> /dev/sda6 / btrfs defaults,noatime,compress=lzo,autodefrag,subvol=ROOT 0 0
>> /dev/sda5 none swap sw 0 0
>>
>> # btrfs su l /
>> ID 257 gen 745235 top level 5 path ROOT
>> ID 258 gen 745235 top level 257 path home
>> ID 498 gen 744743 top level 5 path ROOT.snap
>> ID 501 gen 745043 top level 258 path home/home.snap
>
> Nested subvolumes makes this more complicated in my opinion. You might
> have better luck mounting subvolid=5 to /mnt and using a fully
> qualified pathname for send.
>
>
>
> --
> Chris Murphy
