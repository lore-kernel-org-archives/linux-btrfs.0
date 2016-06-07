Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33926 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbcFGDmv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jun 2016 23:42:51 -0400
Received: by mail-oi0-f49.google.com with SMTP id e72so257508724oib.1
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jun 2016 20:42:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465191858.3381218.628872649.1C5D6003@webmail.messagingengine.com>
References: <1465191858.3381218.628872649.1C5D6003@webmail.messagingengine.com>
Date: Mon, 6 Jun 2016 21:42:45 -0600
Message-ID: <CAJCQCtSYfX3M0DVd9WA+yru8Jm=wwfkmYCUUeeswE9DnsMAG1g@mail.gmail.com>
Subject: Re: btrfs device delete /dev/sdc1 /mnt/raid1 user experience
From: Chris Murphy <lists@colorremedies.com>
To: Kai Hendry <hendry@iki.fi>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 5, 2016 at 11:44 PM, Kai Hendry <hendry@iki.fi> wrote:
> Hi there,
>
>
> I planned to remove one of my disks, so that I can take it from
> Singapore to the UK and then re-establish another remote RAID1 store.
>
> delete is an alias of remove, so I added a new disk (devid 3) and
> proceeded to run:
> btrfs device delete /dev/sdc1 /mnt/raid1 (devid 1)

Wrong command. This means you don't want sdc1 used in this volume
anymore and in the process it is invalidated because to remove it from
Btrfs means to remove its signature.





>
>
> nuc:~$ uname -a
> Linux nuc 4.5.4-1-ARCH #1 SMP PREEMPT Wed May 11 22:21:28 CEST 2016
> x86_64 GNU/Linux
> nuc:~$   btrfs --version
> btrfs-progs v4.5.3
> nuc:~$ sudo btrfs fi show /mnt/raid1/
> Label: 'extraid1'  uuid: 5cab2a4a-e282-4931-b178-bec4c73cdf77
>         Total devices 2 FS bytes used 776.56GiB
>         devid    2 size 931.48GiB used 778.03GiB path /dev/sdb1
>         devid    3 size 1.82TiB used 778.03GiB path /dev/sdd1

OK I'm confused. You had a three drive Btrfs raid-1 and you expected
to take 1 drive on a trip to establish that data elsewhere? That's not
possible. The minimum number of drives for degraded mount of a 3 drive
Btrfs raid1 is 2 drives. There aren't three copies of the data with a
three drive raid1. There are two copies only spread across three
drives.

Your command turned this from a 3 drive volume into a 2 drive volume,
it removed the drive you asked to be removed.



> First off, I was expecting btrfs to release the drive pretty much
> immediately. The command took about half a day to complete. I watched
> `btrfs fi show` to see size of devid 1 (the one I am trying to remove)
> to be zero and to see used space slowly go down whilst used space of
> devid 3 (the new disk) slowly go up.

Expected behavior, it was told you no longer wanted a 3 drive raid1,
so the data on the removed drive was being replicated onto the other
two drives to maintain two copies of your data on those two drives.


> Secondly and most importantly my /dev/sdc1 can't be mounted now anymore.
> Why?

The data that was on that drive is still there, just the magic was
invalidated as the final step in the operation. But that one drive
doesn't contain all of your data anyway so by itself the one drive
won't mount degraded, too many devices are missing.


>
> sudo mount -t btrfs /dev/sdc1 /mnt/test/
> mount: wrong fs type, bad option, bad superblock on /dev/sdc1,
>        missing codepage or helper program, or other error
>
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
>
> There is nothing in dmesg nor my journal. I wasn't expecting my drive to
> be rendered useless on removing or am I missing something?

You're definitely missing something but once you understand how it
actually works, it'll be interesting if you have suggestions on how
the existing documentation confused you into making this mistake.


> I'm still keen to take a TB on a flight with me the day after tomorrow.
> What is the recommended course of action? Recreate a mkfs.btrfs on
> /dev/sdc1 and send data to it from /mnt/raid1?

You can do that. The 2 disk raid1 can be used as the send, and the new
fs on the removed 3rd drive can be used as the receive side. That
would be per subvolume however.

It would be faster to use a btrfs seed device for this. But as I went
through the steps, I got confused how to remove the two raid1s. Both
are read only in this case, so I don't know what happens, it'd require
testing and the seed > sprout stuff isn't as well tested. But at least
it's relatively safe since the original is flagged read only.


> Still I hope the experience could be improved to remove a disk sanely.

Yeah but we'll have to understand at what point you're confused. It
seems like maybe you're not aware that  three drive raid1 still means
two copies of data, not three. Taking one drive would never have
worked anyway.

-- 
Chris Murphy
