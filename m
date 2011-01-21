From: CACook@quantum-sci.com
Subject: Re: Backup Command
Date: Fri, 21 Jan 2011 13:54:57 -0800
Message-ID: <201101211354.58138.CACook@quantum-sci.com>
References: <201101211107.25039.CACook@quantum-sci.com> <AANLkTikpV70ktA4+m1gpKpArMQRTVRQEMPMB=POV5Pue@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikpV70ktA4+m1gpKpArMQRTVRQEMPMB=POV5Pue@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 21 January 2011 11:44:24 Freddie Cash wrote:
> #!/bin/sh
>=20
> ssh someuser@mythtv.pc "/path/to/some/script stop"
>=20
> /path/to/your/rsync/script
>=20
> ssh someuser@mythtv.pc "/path/to/some/script start"

Ho-lee crap, this is fantastic.  Everything seems to work.  I find thou=
gh that if I stop myth -and- mysql, I cannot export the database, so I =
only stop Myth.  It's the only thing using the database anyway, in my c=
ase.

Well it's been 12 hours and I'm still doing my first HTPC data transfer=
, so not all commands are tested (untested=3D=3D#), but I am confident =
they will work.  I'm donating my (weekly) cron script here in case it h=
elps someone. (below)

I have four systems:
hex - work laptop
droog - HTPC with a 4TB btrfs raid0 array on /home and 500GB raptor on =
/
slepnir - backup server in a cube case out in the garage (in case of th=
eft or fire) with a SuperMicro 5 disk hot-swap cage, 6TB so far. (WD Gr=
een 2TB now $80 with rebate!)
phone - Android Nexus One with 16GB SD

The backup server has SSH credentials on the other systems, but only th=
e work laptop can ssh to it (limited by Shorewall).  The backup server =
will also handle security cameras and will presumably dnat a port to th=
e HTPC, which will serve it to the WAN on SSH (reverse tunnel) so I can=
 get motion notifications and video on my phone. (ZoneMinder)  The HTPC=
 is the only system allowed to present anything to the WAN as it has no=
thing sensitive, and -that- will be on a subnet.  Maybe I can limit it =
to my phone's IP.

I do have a (disused) WindowsXP partition, but unsure how to back that =
up.  Maybe ssh with a dd command.

Thanks for the help all.

backups
-----------------------------------------------------------------------=
----------------------------------------------------------
#!/bin/sh
#
# cron.weekly/backups -- schedules periodic backups of darkmatter syste=
ms
#
# Copyleft =C2=A9 Carl Cook
#
#--archive is  equivalent  to  'recursive links perms times group owner=
 DevicesSpecials'

/bin/mount /media/backups

#------------------------------------------------------
# Hex

#/sbin/btrfs subvolume snapshot /media/backups/hex-home/ /media/backups=
/hex-home-snap-$(date +"%Y-%m-%d")
/usr/bin/rsync --archive --checksum --compress --hard-links --delete-du=
ring --delete-excluded --inplace --numeric-ids --log-file=3D/media/back=
ups/hex-home-$(date +"%Y-%m-%d").log -e ssh root@hex:///home/ /media/ba=
ckups/hex-home/

#/sbin/btrfs subvolume snapshot /media/backups/hex-root/ /media/backups=
/hex-root-snap-$(date +"%Y-%m-%d")
#/usr/bin/rsync --archive --checksum --compress --hard-links --delete-d=
uring --delete-excluded --inplace --numeric-ids --exclude-from=3D/media=
/backups/exclude-root --log-file=3D/media/backups/hex-root-$(date +"%Y-=
%m-%d").log -e ssh root@hex:/// /media/backups/hex-root/

#------------------------------------------------------
# Droog

#/sbin/btrfs subvolume snapshot /media/backups/droog-home/ /media/backu=
ps/droog-home-snap-$(date +"%Y-%m-%d")
/usr/bin/rsync --archive --checksum --compress --hard-links --delete-du=
ring --delete-excluded --inplace --numeric-ids --log-file=3D/media/back=
ups/droog-home-$(date +"%Y-%m-%d").log -e ssh root@droog:///home/ /medi=
a/backups/droog-home/

/usr/bin/ssh root@droog "/etc/init.d/mythtv-backend stop"
/usr/bin/ssh root@droog "/usr/bin/mysqldump -u mythtv -pmythtv mythconv=
erg -c > /home/bill/.mythtv/mysql_backup-$(date +"%Y-%m-%d").sql"
/usr/bin/ssh root@droog "/etc/init.d/mythtv-backend start"
/sbin/btrfs subvolume snapshot /media/backups/droog-root/ /media/backup=
s/droog-root-snap-$(date +"%Y-%m-%d")
/usr/bin/rsync --archive --checksum --compress --hard-links --delete-du=
ring --delete-excluded --inplace --numeric-ids --exclude-from=3D/media/=
backups/exclude-root --log-file=3D/media/backups/droog-root-$(date +"%Y=
-%m-%d").log -e ssh root@droog:/// /media/backups/droog-root/

#------------------------------------------------------
# Phone

#/sbin/btrfs subvolume snapshot /media/backups/phone-sd/ /media/backups=
/phone-sd-snap-$(date +"%Y-%m-%d")
#/usr/bin/rsync --archive --checksum --compress --hard-links --delete-d=
uring --delete-excluded --inplace --numeric-ids --log-file=3D/media/bac=
kups/phone-sd-$(date +"%Y-%m-%d").log -e ssh root@hex:///media/disk-1/ =
/media/backups/phone-sd/

#------------------------------------------------------

/bin/umount /media/backups

-----------------------------------------------------------------------=
----------------------------------------------------------
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
