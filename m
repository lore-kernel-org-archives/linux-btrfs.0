Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34993 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbbDGRGK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 13:06:10 -0400
Received: by lbbuc2 with SMTP id uc2so44251321lbb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 10:06:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150407164010.GL13864@carfax.org.uk>
References: <CAK1hC9skBYrM7nPyU-2mCuey6VkFOGMUCi0umYduX3ePNJ2mpg@mail.gmail.com>
	<CAK1hC9tBAvqOhGLGcX=1Ls2QwtaB6fe6Wzf89vH4=Y+kvxHR_Q@mail.gmail.com>
	<20150407110354.GH13864@carfax.org.uk>
	<CAK1hC9vDQ4j3CZ=7T30-Sg+Q8FYFOzntgmz57WMWRU5WELpDnA@mail.gmail.com>
	<20150407142030.GK13864@carfax.org.uk>
	<CAK1hC9s6ArS7-2wi-PFA9-RyTJv5T+gtHZ=U2NY-tS24UE3f6g@mail.gmail.com>
	<20150407164010.GL13864@carfax.org.uk>
Date: Tue, 7 Apr 2015 19:06:08 +0200
Message-ID: <CAK1hC9v2naewHdBz2jaz598E2DqO4WvJX3BiH2P9xeGqDopBfQ@mail.gmail.com>
Subject: Re: btrfs subvolume & default subvolume
From: arnaud gaboury <arnaud.gaboury@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, arnaud gaboury <arnaud.gaboury@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 7, 2015 at 6:40 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Apr 07, 2015 at 06:31:36PM +0200, arnaud gaboury wrote:
>> On Tue, Apr 7, 2015 at 4:20 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> > On Tue, Apr 07, 2015 at 01:08:59PM +0200, arnaud gaboury wrote:
>> >> On Tue, Apr 7, 2015 at 1:03 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> >> > On Tue, Apr 07, 2015 at 12:58:28PM +0200, arnaud gaboury wrote:
>> > [snip]
>> >> >> After more reading, it seems to me creating a top root subvolume is
>> >> >> the right thing to do:
>> >> >> # btrfs subvolume create root
>> >> >> # btrfs subvolume create root/var
>> >> >> # btrfs subvolume create root/home
>> >> >>
>> >> >> Am I right?
>> >> >
>> >> >    Not how I'd recommend doing it. I'd say:
>> >> >
>> >> > # btrfs sub crea root
>> >> > # btrfs sub crea var
>> >> > # btrfs sub crea home
>> >> >
>> >> >    Then fstab:
>> >> >
>> >> > LABEL=myfs    /      btrfs    subvol=root         0 0
>> >> > LABEL=myfs    /var   btrfs    subvol=var          0 0
>> >> > LABEL=myfs    /home  btrfs    subvol=home         0 0
>> >> >
>> >> >    And finally, add this to your kernel command line in the bootloader
>> >> > to specify how to mount root:
>> >> >
>> >> > rootflags=subvol=root
>> >> >
>> >> >    Hugo.
>> >>
>> >> Thank you Hugo. May you please tell why your recommendation is better
>> >> than my settings, if I thereafter make root as the default sub-volume?
>> >> I changed the root name to active and avoid any confusion:
>> >
>> >    Well, keeping the subvolumes separate from each other, rather than
>> > nested, makes it a bit easier to do things like replace one subvolume
>> > with an earlier snapshot. If you nest them, then your recovery process
>> > from (say) a screwed-up / looks a bit like this:
>> >
>> > # mount -o subvolid=0 /dev/sda1 /media/btrfs
>> > # mv /media/btrfs/root /media/btrfs/old-root
>> > # btrfs sub snap /media/btrfs/old-root/snapshots/last-root /media/btrfs/root
>> > # btrfs sub snap /media/btrfs/old-root/var /media/btrfs/root/var
>> > # btrfs sub snap /media/btrfs/old-root/home /media/btrfs/root/home
>> > # btrfs sub set-default $n /media/btrfs
>> > # umount /media/btrfs
>> >
>> >    If you don't nest them, and don't use set-default, then the same
>> > recovery process would look like this:
>> >
>> > # mount -o subvolid=0 /dev/sda1 /media/btrfs
>> > # mv /media/btrfs/root /media/btrfs/old-root
>> > # mv /media/btrfs/snapshots/last-root /media/btrfs/root
>> > # umount /media/btrfs
>> >
>> >    (This also explains why I wouldn't use set-default, but instead
>> > mount / using a subvol=<path> option).
>> >
>> >    Now, for making the snapshots in the first place, with nested
>> > subvolumes, your snapshot script looks a bit like this:
>> >
>> > # btrfs sub snap / /snapshots/last-root
>> >
>> > and with the approach I'd recommend, it looks like this:
>> >
>> > # mount -o subvolid=0 /dev/sda1 /media/btrfs
>> > # btrfs sub snap /media/btrfs/root /media/btrfs/snapshots/last-root
>> > # umount /media/btrfs
>> >
>> > which is a little more complex, but the approach is precisely similar
>> > to the recovery process: mount the top level of the FS on
>> > /media/btrfs, manipulate the subvolumes, and then unmount. This keeps
>> > the management of subvolumes a completely separate concern from the
>> > structure of the filesystem tree.
>> >
>> >    Hugo.
>>
>> Thank you for all these info.
>> Here is my setup now. I hope I fully understand all the hints.
>>
>> $ cd /mnt/btrfs
>> # btrfs subvolume create active  ---> Just in case I want to add
>> another subvolumes
>> # btrfs subvolume create active/rootvol
>> # btrfs subvolume create active/home
>> # btrfs subvolume create active/var
>> # btrfs subvolume create active/etc
>
>    One minor thing -- you've still got nested subvolumes here. You can
> still run into the same kinds of management problems (not being able
> to use mv efficiently to move subvolumes around). "active" doesn't
> need to be a subvolume, it can (and, I'd argue, should) be an ordinary
> directory.
>
>    Hugo.

So in mnt/btrfs,
# btrfs subvolume delete ...
deleted all subvolumes. Checked list was empty. Then:
$ cd /mnt/btrfs
# btrfs subvolume create rootvol
# btrfs subvolume create home
# btrfs subvolume create var
# btrfs subvolume create etc

Basic and no nested volumes.
No default subvolume.

Is this finally correct?

Thank you

>
> --
> Hugo Mills             | What do you give the man who has everything?
> hugo@... carfax.org.uk | Penicillin is a good start...
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |



-- 

google.com/+arnaudgabourygabx
