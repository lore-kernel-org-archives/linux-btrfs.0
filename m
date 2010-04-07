From: Andrew Carlson <naclosagc@gmail.com>
Subject: Re: btrfs error: 'disk full' although 8 of 21 GB free
Date: Wed, 7 Apr 2010 12:38:38 -0500
Message-ID: <q2o6842966e1004071038v312529aate98a9f31939b2b1f@mail.gmail.com>
References: <201004071659.03927.markotahal@gmail.com>
	 <20100407154823.GA2315@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Marek Otahal <markotahal@gmail.com>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100407154823.GA2315@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

I can tell you from experience that the later unstable git pull works
much better in this regard.  I have a 299GB filesystem compressed to
1.2TB full with 507M free.  And it handles the ENOSPC condition like
it should.

On Wed, Apr 7, 2010 at 10:48 AM, Josef Bacik <josef@redhat.com> wrote:
> On Wed, Apr 07, 2010 at 04:59:02PM +0200, Marek Otahal wrote:
>> Hi,
>> I'm running archlinux, kernel 2.6.33.2, btrfs-progs 0.19.
>> I was copying a folder (cca 2GB) to a btrfs partition(8GB free) and =
got a
>> 'disk full' error message. Had to kill the process and remove the fi=
les
>> otherwise apps report full disk.
>> I can always reproduce this by creating some big files on the partit=
ion.
>> Since then, btrfsck reports errors, is there a way to fix them?
>> Thank you, Mark
>>
>> // here follows contents of files attached for your comfort
>>
>> Here are some clues:
>>
>> *output of df -h:
>>
>> Filesystem =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used Avail Use% Mounted on
>> /dev/sda5 =A0 =A0 =A0 =A0 =A0 =A0 =A020G =A0 13G =A06.0G =A068% /
>> udev =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 10M =A0248K =A09.8M =A0 3% =
/dev
>> none =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01.0G =A0 =A0 0 =A01.0G =A0 0=
% /dev/shm
>> /dev/mapper/homeDevice
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A021G =A0 13G =A08.0G =A0=
62% /home
>> tmpfs =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 3.0G =A0 29M =A03.0G =A0 1% /t=
mp
>> /dev/sda8 =A0 =A0 =A0 =A0 =A0 =A0 3.4G =A02.3G =A0976M =A071% /var
>> /dev/sda2 =A0 =A0 =A0 =A0 =A0 =A0 145M =A0 20M =A0118M =A015% /boot
>> /dev/mapper/storeDevice
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A040G =A0 38G =A02.0G =A0=
96% /mnt/store
>> /dev/sda10 =A0 =A0 =A0 =A0 =A0 =A0 18G =A09.1G =A07.4G =A056% /mnt/r=
ecovery
>> /dev/sda12 =A0 =A0 =A0 =A0 =A0 =A09.8G =A09.6G =A0206M =A098% /media=
/disk
>> /dev/sda1 =A0 =A0 =A0 =A0 =A0 =A0 =A030G =A0 22G =A07.5G =A075% /mnt=
/winxp
>>
>> * I've heard df has issues with btrfs, but du -sh /mountpoint report=
s approx
>> same size used
>>
>> *btrfsck /dev/mapper/homeDevice - is there a way to fix these errors=
?? I'm
>> worried to take snapshots or defragment not to make it worse.
>>
>
> Some work has been done in this area recently. =A0Can you run with th=
e latest
> btrfs-unstable tree? =A0Df will tell you something that is more along=
 the lines
> with what you are expecting, and you can use the new btrfs-progs-unst=
able tree
> and run a
>
> btrfs filesystem df /mount/point
>
> and it will spit out specific space info that will be helpfull. =A0Th=
anks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Andy Carlson
-----------------------------------------------------------------------=
----
Gamecube:$150,PSO:$50,Broadband Adapter: $35, Hunters License: $8.95/mo=
nth,
The feeling of seeing the red box with the item you want in it:Priceles=
s.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
