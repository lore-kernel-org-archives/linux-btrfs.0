From: cwillu <cwillu@cwillu.com>
Subject: Re: Cannot Deinstall a Debian Package
Date: Thu, 5 May 2011 15:48:49 -0600
Message-ID: <BANLkTi=qRCM3Rt5oBkCfxi4af2GYeHWJGg@mail.gmail.com>
References: <201105031227.43619.CACook@quantum-sci.com>
	<201105051332.20992.CACook@quantum-sci.com>
	<BANLkTim3uMUXN7Q=zqXoopUeR8gphWHi_Q@mail.gmail.com>
	<201105051440.07434.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105051440.07434.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 5, 2011 at 3:40 PM,  <CACook@quantum-sci.com> wrote:
> On Thursday 5 May, 2011 13:40:25 cwillu wrote:
>> Could you include the information I asked for previously? =C2=A0(Ker=
nel
>> version, output of btrfs fi df and btrfs fi show)
>
> Kernel 2.6.37-2
> # btrfs fi df /home
> Data, RAID0: total=3D2.61TB, used=3D2.47TB
> Data: total=3D8.00MB, used=3D8.00MB
> System, RAID1: total=3D8.00MB, used=3D196.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, RAID1: total=3D6.88GB, used=3D4.64GB
> Metadata: total=3D8.00MB, used=3D0.00
> # df /dev/sdb
> Filesystem =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1K-blocks =C2=A0 =C2=A0=
 =C2=A0Used Available Use% Mounted on
> /dev/sdb =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 3907029168 2659716=
272 1242565920 =C2=A069% /home
> # df /dev/sdc
> Filesystem =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1K-blocks =C2=A0 =C2=A0=
 =C2=A0Used Available Use% Mounted on
> udev =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1=
895384 =C2=A0 =C2=A0 =C2=A0 268 =C2=A0 1895116 =C2=A0 1% /dev
> (this doesn't make any sense)
> # btrfs fi show
> failed to read /dev/sdg
> failed to read /dev/sdf
> failed to read /dev/sde
> failed to read /dev/sdd
> failed to read /dev/sr0
> Label: none =C2=A0uuid: 85537aa8-30dc-4f87-ac55-6c8344304184
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Total devices 2 FS bytes used 2.47TB
> =C2=A0 =C2=A0 =C2=A0 =C2=A0devid =C2=A0 =C2=A01 size 1.82TB used 1.31=
TB path /dev/sdb
> =C2=A0 =C2=A0 =C2=A0 =C2=A0devid =C2=A0 =C2=A02 size 1.82TB used 1.31=
TB path /dev/sdc
> Btrfs Btrfs v0.19
>
>
>> Defrag is not the same as balancing, and neither is quite the same a=
s
>> the balancing of the internal b-trees that make up the filesystem.
>
> I know they're not the same. =C2=A0But I am asking:
>
> I thought balancing was supposed to be automatic in BTRFS?
>
> Is defrag not automatic?

=46air enough.

Btrfs works mostly like ext in this sense:  the way it reads and
writes data generally avoids fragmentation.  There are some issues in
this area still, but they're not the cause of no-space problems
typically, rather they tend to cause performance loss.

A "balance" operation is more about balancing the space use of the
large allocations btrfs makes from its pool of free disk-space to one
of the block groups that holds data or metadata.  "mkdir" failing
while you still have lots of disk space free would typically mean
something along the lines of:  all the free disk space has been
allocated to either the metadata or data block groups, and the
metadata block groups are full.  This sort of behaviour has mostly
gone away in the last couple releases, although it would take a
balance operation (as you performed) to get everything working right.

How old was the filesystem?  It might just have been lingering
problems from an older kernel, which would be cleared up entirely by
the balance you just ran.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
