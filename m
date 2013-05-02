Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58243 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940Ab3EBUmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 May 2013 16:42:20 -0400
Received: by mail-oa0-f46.google.com with SMTP id j6so1002264oag.19
        for <linux-btrfs@vger.kernel.org>; Thu, 02 May 2013 13:42:19 -0700 (PDT)
MIME-Version: 1.0
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Date: Thu, 2 May 2013 22:41:59 +0200
Message-ID: <CADn-QaPQ0aH1rb3rG3bE87Ka3XaLzHHeA6nwNLbQJsbB_BiXkw@mail.gmail.com>
Subject: Creating recursive snapshots for all filesystems
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello once more...

I'm on Ubuntu 13.04 with Ubuntu kernel 3.8.0-19-lowlatency and
Btrfs v0.20-rc1.

(Did I say that before...? *G*)

Okay, ATM I'm writing a script for creating snapshots for "backups" of
all my btrfs filesystems. I come from a FreeBSD / Solaris background
with heavy use of ZFS.

In ZFS, it's very easy to create snapshots of all "zpools"
("filesystems") of the system, like so:

SnapName=backup.`date +%Y%m%d--%H%M%S`
zpool list -Ho name | while read zpool; do
  zfs snapshot -r $zpool@$SnapName &
done ; wait

Well… How to do something like this with btrfs? I do _not_ want to
have to manually list the filesystems/subvolumes I've got in some
script or configuration file.

Where I'm hanging right now, is that I can't seem to figure out a
"bullet proof" way to find all the subvolumes of the filesystems I
might have.

I've got this:

root@ask-home:~# btrfs fi show
failed to read /dev/sr0
Label: 'Data'  uuid: 7d2eb10f-aced-4d41-bb7f-7badbf075b6a
Total devices 1 FS bytes used 27.96GB
devid    1 size 35.00GB used 35.00GB path /dev/dm-0

Label: 'KernBtrfs'  uuid: 8b16bc2a-43e3-40da-89f5-7b333c6682f3
Total devices 1 FS bytes used 655.05MB
devid    1 size 11.85GB used 6.04GB path /dev/sda11

Btrfs v0.20-rc1

root@ask-home:~# mount -t btrfs
/dev/mapper/ssd-Data on /data type btrfs (rw,noatime,ssd,discard)
/dev/mapper/ssd-Data on /home type btrfs (rw,noatime,ssd,discard,subvol=home)
/dev/sda11 on /data/Kernel/KernBtrfs type btrfs (rw,noatime)

Now, how would I find all the subvolumes of the btrfs with the label
"Data" (or uuid 7d...) or /dev/dm-0? "btrfs subvolume list" only seems
to operate on where a btrfs is mounted. It works on "path".

I could do "btrfs subv list -a /data", but how would I figure out,
that "/data" is the "root" of the filesystem with uuid 7d...?

For now, I do something like this (-> http://pastebin.com/u08ub1i8):

SnapName=backup.`date +%Y%m%d--%H%M%S`
btrfs fi show 2>/dev/null | awk '/ path / {print $NF}' | while read path; do
  SafePath=`echo "$path" | tr / .`
  TmpMountDir=`mktemp -d /tmp/.btrfs.mount.$SafePath.XXXXXX`
  mount -t btrfs $path $TmpMountDir
  (btrfs subv list -ar $TmpMountDir; btrfs subv list -a $TmpMountDir)
| sort | uniq -u | while read _id Id _gen Gen _top _level Toplevel
_path Path; do
    btrfs subv snaps -r "$TmpMountDir/$Path" "$TmpMountDir/$Path.$SnapName"
  done
  umount $TmpMountDir
  rmdir $TmpMountDir
done

Now, this works, but seems "somewhat" complicated... But
maybe I'm just spoiled by ZFS ;)

Is there an easier way to achieve what I want? I want to achieve:

Creating recursive snapshots for all filesystems

;)

Thanks,

Alexander
--
=>        Google+ => http://plus.skwar.me         <==
=> Chat (Jabber/Google Talk) => a.skwar@gmail.com <==
