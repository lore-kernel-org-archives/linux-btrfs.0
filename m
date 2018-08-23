Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35710 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbeHWXrD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 19:47:03 -0400
Received: by mail-lj1-f195.google.com with SMTP id p10-v6so5148534ljg.2
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 13:15:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA3ktqnSR59hSxpj1Pme-3fqJBqNu-A_kRu-VmX-5NrVpjHOoQ@mail.gmail.com>
References: <CAA3ktqnSR59hSxpj1Pme-3fqJBqNu-A_kRu-VmX-5NrVpjHOoQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 23 Aug 2018 14:15:43 -0600
Message-ID: <CAJCQCtT-SwNYwLktME97RaC-NQTaCdq8JqWTDaeZhfZOzk6MXw@mail.gmail.com>
Subject: Re: Device Delete Stalls
To: Stefan Malte Schumacher <s.schumacher@netcologne.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 23, 2018 at 8:04 AM, Stefan Malte Schumacher
<s.schumacher@netcologne.de> wrote:
> Hallo,
>
> I originally had RAID with six 4TB drives, which was more than 80
> percent full. So now I bought
> a 10TB drive, added it to the Array and gave the command to remove the
> oldest drive in the array.
>
>  btrfs device delete /dev/sda /mnt/btrfs-raid
>
> I kept a terminal with "watch btrfs fi show" open and It showed that
> the size of /dev/sda had been set to zero and that data was being
> redistributed to the other drives. All seemed well, but now the
> process stalls at 8GB being left on /dev/sda/. It also seems that the
> size of the drive has been reset the original value of 3,64TiB.
>
> Label: none  uuid: 1609e4e1-4037-4d31-bf12-f84a691db5d8
>         Total devices 7 FS bytes used 8.07TiB
>         devid    1 size 3.64TiB used 8.00GiB path /dev/sda
>         devid    2 size 3.64TiB used 2.73TiB path /dev/sdc
>         devid    3 size 3.64TiB used 2.73TiB path /dev/sdd
>         devid    4 size 3.64TiB used 2.73TiB path /dev/sde
>         devid    5 size 3.64TiB used 2.73TiB path /dev/sdf
>         devid    6 size 3.64TiB used 2.73TiB path /dev/sdg
>         devid    7 size 9.10TiB used 2.50TiB path /dev/sdb
>
> I see no more btrfs worker processes and no more activity in iotop.
> How do I proceed? I am using a current debian stretch which uses
> Kernel 4.9.0-8 and btrfs-progs 4.7.3-1.
>
> How should I proceed? I have a Backup but would prefer an easier and
> less time-comsuming way out of this mess.

I'd let it keep running as long as you can tolerate it. In the
meantime, update your backups, and keep using the file system
normally, it should be safe to use. The block group migration can
sometimes be slow with "brfs dev del" compared to the replace
operation, I can't explain why but it might be related to some
combination of file and free space fragmentation as well as number of
snapshots, and just general complexity of what is effectively a
partial balance operation going on.

Next, you could do a sysrq + t, which dumps process state into the
kernel message buffer which might not be big enough to contain the
output. If you're using systemd, the journal -k will have it, and
presumably syslog's messages will have it. I can't parse this output
but a developer might find it useful to see what's going on and if
it's just plain wrong. Or if it's just slow.

Next, once you get sick of waiting, well you can force a reboot with
'reboot -f' or 'sysrq + b' but then what's the plan? Sure you could
just try again but I don't know that this should give different
results. It's either just slow, or it's a bug. And if it's a bug,
maybe it's fixed in something newer, in which case I'd try a much
newer kernel 4.14 at the oldest, and ideally 4.18.4, at least to
finish off this task.

For what it's worth, the bulk of the delete operation is like a
filtered balance, it's mainly relocating block groups, and that is
supposed to be COW. So it should be safe to do an abrupt reboot. If
you're not writing new information there's no information to lose; the
worst case is Btrfs has a slightly older superblock than the latest
generation for block group relocation and it starts from that point
again. I've done quite a lot of jerkface reboot -f and sysrq + b with
Btrfs and have never broken a file system so far (power failures,
different story) but maybe I'm lucky and I have a bunch of well
behaved devices.



-- 
Chris Murphy
