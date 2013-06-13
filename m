Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:44358 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899Ab3FMWvD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Jun 2013 18:51:03 -0400
Received: by mail-ie0-f179.google.com with SMTP id c10so19611182ieb.10
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jun 2013 15:51:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130613212100.GG11290@carfax.org.uk>
References: <51BA34EC.1080800@friedels.name>
	<20130613212100.GG11290@carfax.org.uk>
Date: Thu, 13 Jun 2013 16:51:01 -0600
Message-ID: <CAE5mzvgEt_HHrtzRrKB4_vap1j7-uh73M=DkeYGeVLuHoHm_5w@mail.gmail.com>
Subject: Re: raid0, raid1, raid5, what to choose?
From: cwillu <cwillu@cwillu.com>
To: Hugo Mills <hugo@carfax.org.uk>, Hendrik Friedel <hendrik@friedels.name>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 13, 2013 at 3:21 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, Jun 13, 2013 at 11:09:00PM +0200, Hendrik Friedel wrote:
>> Hello,
>>
>> I'd appreciate your recommendation on this:
>>
>> I have three hdd with 3TB each. I intend to use them as raid5 eventually.
>> currently I use them like this:
>>
>> # mount|grep sd
>> /dev/sda1 on /mnt/Datenplatte type ext4
>> /dev/sdb1 on /mnt/BTRFS/Video type btrfs
>> /dev/sdb1 on /mnt/BTRFS/rsnapshot type btrfs
>>
>> #df -h
>> /dev/sda1       2,7T  1,3T  1,3T  51% /mnt/Datenplatte
>> /dev/sdb1       5,5T  5,4T   93G  99% /mnt/BTRFS/Video
>> /dev/sdb1       5,5T  5,4T   93G  99% /mnt/BTRFS/rsnapshot
>>
>> Now, what surprises me, and here I lack memory- is that sdb appears
>> twice.. I think, I created a raid1, but how can I find out?
>
>    Appearing twice in that list is more an indication that you have
> multiple subvolumes -- check the subvol= options in /etc/fstab
>
>> #/usr/local/smarthome# ~/btrfs/btrfs-progs/btrfs fi show /dev/sdb1
>> Label: none  uuid: 989306aa-d291-4752-8477-0baf94f8c42f
>>         Total devices 2 FS bytes used 2.68TB
>>         devid    2 size 2.73TB used 2.73TB path /dev/sdc1
>>         devid    1 size 2.73TB used 2.73TB path /dev/sdb1
>>
>> Now, I wanted to convert it to raid0, because I lack space and
>> redundancy is not important for the Videos and the Backup, but this
>> fails:
>> ~/btrfs/btrfs-progs/btrfs fi balance start -dconvert=raid0  /mnt/BTRFS/
>> ERROR: error during balancing '/mnt/BTRFS/' - Inappropriate ioctl for device
>
>    /mnt/BTRFS isn't a btrfs subvol, according to what you have listed
> above. It's a subdirectory in /mnt which is contains two subdirs
> (Video and rsnapshot) which are used as mountpoints for subvolumes.
>
>    Try running the above command with /mnt/BTRFS/Video instead (or
> rsnapshot -- it doesn't matter which).
>
>> dmesg does not help here.
>>
>> Anyway: This gave me some time to think about this. In fact, as soon
>> as raid5 is stable, I want to have all three as a raid5. Will this
>> be possible with a balance command? If so: will this be possible as
>> soon as raid5 is stable, or will I have to wait longer?
>
>    Yes, it's possible to convert to RAID-5 right now -- although the
> code's not settled down into its final form quite yet. Note that
> RAID-5 over two devices won't give you any space benefits over RAID-1
> over two devices. (Or any reliability benefits either).
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>        --- "Are you the man who rules the Universe?" "Well,  I ---
>                               try not to."

Raid5 currently is only suitable for testing: it's known and expected
to break on power cuts, for instance.  The parity logging stuff is
waiting on the skip-list implementation you may have read about on
lwn, otherwise the performance overhead wasn't acceptable or some
such.
