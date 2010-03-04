From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: Issues when volume is full
Date: Thu, 4 Mar 2010 14:20:35 -0700
Message-ID: <c5b98f841003041320w3abfc3acrdd6e46d0475883aa@mail.gmail.com>
References: <c5b98f841003041258u720a2b0dwe7e02254e2ca617b@mail.gmail.com>
	 <20100304211009.GB8678@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100304211009.GB8678@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 4, 2010 at 2:10 PM, Josef Bacik <josef@redhat.com> wrote:
> On Thu, Mar 04, 2010 at 01:58:22PM -0700, Robert LeBlanc wrote:
>> I've been using btrfs as a spool space on our back-up server to get
>> familiar with it and things work fine until the volume fills up. Our
>> backup software (bacula) usually spools until the volume is full, th=
en
>> despools and respools, etc. With btrfs, it fills up and bacula think=
s
>> there is still space so it keeps trying and then finally errors out.=
 I
>> thought this was a problem because I was using compression, but I've
>> repeated the problem without compression. Doing some tests, this is
>> what I've found:
>>
>> lsddomainsd:/spool# dd if=3D/dev/zero of=3Djunk bs=3D1024000
>> dd: writing `junk': No space left on device
>> 522163+0 records in
>> 522162+0 records out
>> 534693888000 bytes (535 GB) copied, 6026.85 s, 88.7 MB/s
>> lsddomainsd:/spool# ls
>> junk
>> lsddomainsd:/spool# df -h
>> Filesystem=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Size=A0 Used Avail Use% =
Mounted on
>> /dev/mapper/lsddomain-root
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 6.5G=
=A0 3.5G=A0 2.7G=A0 58% /
>> tmpfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.0G=A0=A0=A0=A0=
 0=A0 2.0G=A0=A0 0% /lib/init/rw
>> udev=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 10M=A0 17=
2K=A0 9.9M=A0=A0 2% /dev
>> tmpfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.0G=A0=A0=A0=A0=
 0=A0 2.0G=A0=A0 0% /dev/shm
>> /dev/sda1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 228M=A0=A0 92M=A0 124M=
=A0 43% /boot
>> /dev/mapper/lsddomain-home
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 4.6G=
=A0 138M=A0 4.5G=A0=A0 3% /home
>> 192.168.58.2:/backup/bacula
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.5T=
=A0 996G=A0 1.5T=A0 40% /backup
>> /dev/mapper/spool=A0=A0=A0=A0 500G=A0 499G=A0 1.6G 100% /spool
>> lsddomainsd:/spool# dd if=3D/dev/zero of=3Djunk2 bs=3D1024000
>> dd: writing `junk2': No space left on device
>> 1+0 records in
>> 0+0 records out
>> 0 bytes (0 B) copied, 0.0704083 s, 0.0 kB/s
>> lsddomainsd:/spool# dd if=3D/dev/zero of=3Djunk3 bs=3D1024000
>> dd: writing `junk3': No space left on device
>> 1+0 records in
>> 0+0 records out
>> 0 bytes (0 B) copied, 0.108706 s, 0.0 kB/s
>> lsddomainsd:/spool# ls -lh
>> total 498G
>> -rw-r--r-- 1 root root 498G 2010-03-04 09:54 junk
>> -rw-r--r-- 1 root root=A0=A0=A0 0 2010-03-04 13:45 junk2
>> -rw-r--r-- 1 root root=A0=A0=A0 0 2010-03-04 13:45 junk3
>> lsddomainsd:/spool#
>>
>> So even though the volume is full it shows space left. Is this
>> supposed to happen? I don't remember seeing any space left on other
>> file systems and I've filled quite a few.
>>
>
> Yeah this is an unfortunate side-affect of how we currently do df. =A0=
We plan on
> changing it, but currently it just shows data used in the used column=
, so the
> 1.6G will be whats been reserved for metadata space. =A0IIRC the cons=
ensus was to
> count the used amount from all spaces, and then just add the free una=
llocated
> space to that, but it will still likely end up with "Avail" having wh=
at is free
> for metadata space, but not actually able to be used as data. =A0Than=
ks,
>
> Josef
>

So is it possible to prevent the creation of metadata if there is no
data blocks left. I wonder if that would solve this issue. Maybe if
Bacula sees it can't write a file at all, it then goes into
despooling. I wonder if other programs (cp, rsync, etc) will run into
the same problem when the volume is full. I know it's a corner case,
so I'm not going to press the issue when btrfs is not close to stable.
Just an issue I came across and thought I'd get some additional info
about.

Robert LeBlanc
Life Sciences & Undergraduate Education Computer Support
Brigham Young University
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
