From: Oliver =?UTF-8?Q?Ve=C4=8Dernik?= <ov@vecernik.at>
Subject: Re: migrating drives (device delete)
Date: Wed, 10 Nov 2010 13:15:51 +0100
Message-ID: <1289391351.20690.46.camel@jeezo>
References: <B$bHV4Xy1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <B$bHV4Xy1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo Helmut,

> What tells "df": about 300 GByte in use?

# df -h | head -n 2 
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2             844G  293G  552G  35% /
# btrfs filesystem df /
Metadata: total=896.00MB, used=484.77MB
Data: total=291.50GB, used=291.15GB
System: total=12.00MB, used=28.00KB

> And I haven't told the system to make a "raid0". I've created the first  
> btrfs partition only with
> 
>         mkfs.btrfs /dev/sdxn

I also just started with:

# mkfs.btrfs /dev/sda2

> And I haven't used "degraded" after balancing the 2 partitions.

# mount -o remount /dev/sdb2 /
# df -h 
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2             844G  293G  552G  35% /
none                  429M  200K  429M   1% /dev
none                  435M     0  435M   0% /dev/shm
none                  435M   48K  435M   1% /var/run
none                  435M     0  435M   0% /var/lock
/dev/sdc1             2.0G   26M  1.9G   2% /boot
# btrfs device delete /dev/sda2 /
ERROR: error removing the device '/dev/sda2'

> The "balance" command may take a long time; I've just seen about 2 days  
> for 1.5 TByte.

I balanced immediately after installing the server.  It was less than
1GB and took just a couple of seconds.

The only idea I have now is to copy everthing to a new fs, chroot into
it and update-grub.  Is this the best way to go?

-- 
Regards,
Oliver

