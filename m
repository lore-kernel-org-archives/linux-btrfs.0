From: Josef Bacik <josef@redhat.com>
Subject: Re: Issues when volume is full
Date: Thu, 4 Mar 2010 16:10:09 -0500
Message-ID: <20100304211009.GB8678@localhost.localdomain>
References: <c5b98f841003041258u720a2b0dwe7e02254e2ca617b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c5b98f841003041258u720a2b0dwe7e02254e2ca617b@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 04, 2010 at 01:58:22PM -0700, Robert LeBlanc wrote:
> I've been using btrfs as a spool space on our back-up server to get
> familiar with it and things work fine until the volume fills up. Our
> backup software (bacula) usually spools until the volume is full, the=
n
> despools and respools, etc. With btrfs, it fills up and bacula thinks
> there is still space so it keeps trying and then finally errors out. =
I
> thought this was a problem because I was using compression, but I've
> repeated the problem without compression. Doing some tests, this is
> what I've found:
>=20
> lsddomainsd:/spool# dd if=3D/dev/zero of=3Djunk bs=3D1024000
> dd: writing `junk': No space left on device
> 522163+0 records in
> 522162+0 records out
> 534693888000 bytes (535 GB) copied, 6026.85 s, 88.7 MB/s
> lsddomainsd:/spool# ls
> junk
> lsddomainsd:/spool# df -h
> Filesystem=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Size=A0 Used Avail Use% M=
ounted on
> /dev/mapper/lsddomain-root
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 6.5G=A0=
 3.5G=A0 2.7G=A0 58% /
> tmpfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.0G=A0=A0=A0=A0=
 0=A0 2.0G=A0=A0 0% /lib/init/rw
> udev=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 10M=A0 172=
K=A0 9.9M=A0=A0 2% /dev
> tmpfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.0G=A0=A0=A0=A0=
 0=A0 2.0G=A0=A0 0% /dev/shm
> /dev/sda1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 228M=A0=A0 92M=A0 124M=A0=
 43% /boot
> /dev/mapper/lsddomain-home
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 4.6G=A0=
 138M=A0 4.5G=A0=A0 3% /home
> 192.168.58.2:/backup/bacula
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.5T=A0=
 996G=A0 1.5T=A0 40% /backup
> /dev/mapper/spool=A0=A0=A0=A0 500G=A0 499G=A0 1.6G 100% /spool
> lsddomainsd:/spool# dd if=3D/dev/zero of=3Djunk2 bs=3D1024000
> dd: writing `junk2': No space left on device
> 1+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.0704083 s, 0.0 kB/s
> lsddomainsd:/spool# dd if=3D/dev/zero of=3Djunk3 bs=3D1024000
> dd: writing `junk3': No space left on device
> 1+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.108706 s, 0.0 kB/s
> lsddomainsd:/spool# ls -lh
> total 498G
> -rw-r--r-- 1 root root 498G 2010-03-04 09:54 junk
> -rw-r--r-- 1 root root=A0=A0=A0 0 2010-03-04 13:45 junk2
> -rw-r--r-- 1 root root=A0=A0=A0 0 2010-03-04 13:45 junk3
> lsddomainsd:/spool#
>=20
> So even though the volume is full it shows space left. Is this
> supposed to happen? I don't remember seeing any space left on other
> file systems and I've filled quite a few.
>=20

Yeah this is an unfortunate side-affect of how we currently do df.  We =
plan on
changing it, but currently it just shows data used in the used column, =
so the
1.6G will be whats been reserved for metadata space.  IIRC the consensu=
s was to
count the used amount from all spaces, and then just add the free unall=
ocated
space to that, but it will still likely end up with "Avail" having what=
 is free
for metadata space, but not actually able to be used as data.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
