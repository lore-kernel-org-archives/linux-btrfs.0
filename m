From: Chester <somethingsome2000@gmail.com>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Wed, 11 Apr 2012 11:38:33 -0500
Message-ID: <CAAE6i0jU99ySXNQzyed+YotRzXcieUzDCZJU0Ju0r0b+AxZjhg@mail.gmail.com>
References: <1333986823.2928.6.camel@ayu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Calvin Walton <calvin.walton@kepstin.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1333986823.2928.6.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 9, 2012 at 10:53 AM, Calvin Walton <calvin.walton@kepstin.c=
a> wrote:
>
> Hi,
>
> I have a system that's using a dracut-generated initramfs to mount a
> btrfs root. After upgrading to kernel 3.4.0-rc2 to test it out, I've
> noticed that the process of mounting the root filesystem takes much
> longer with 3.4.0-rc2 than it did with 3.3.1 - nearly 30 seconds slow=
er!
>
> Does anyone have any ideas? I'm going to try bisecting the issue to s=
ee
> if I can narrow down the cause. I've included excerpts from dmesg of =
the
> bad and good kernels here, and attached the complete dmesg from the b=
ad
> kernel, in case it has anything interesting that I've trimmed out her=
e.
>
> slow:
> [ =A0 =A00.000000] Linux version 3.4.0-rc2 (cwalton@ayu) (gcc version=
 4.6.3
> (Exherbo gcc-4.6.3) ) #57 SMP PREEMPT Mon Apr 9 11:19:43 EDT 2012
> [ =A0 =A00.000000] Command line:
> root=3DUUID=3D43969cd0-4aca-4297-bfbe-952a692f7d55
> rootflags=3Dsubvolid=3D262,compress=3Dlzo,autodefrag,space_cache,inod=
e_cache,noatime
> mtrr_chunk_size=3D512M quiet
> <snip>
> [ =A0 =A01.058257] udevd[701]: starting version 182
> [ =A0 =A01.389606] device label Linux data devid 1 transid 611923 /de=
v/sda4
> [ =A0 =A01.498659] dracut: Checking, if btrfs device complete
> [ =A0 =A01.644808] device label Linux data devid 1 transid 611923 /de=
v/sda4
> [ =A0 =A01.647993] btrfs: disk space caching is enabled
> [ =A0 =A02.180836] device label Linux data devid 1 transid 611923 /de=
v/sda4
> [ =A0 =A02.181663] btrfs: use lzo compression
> [ =A0 =A02.181667] btrfs: enabling auto defrag
> [ =A0 =A02.181670] btrfs: enabling inode map caching
> [ =A0 =A02.181672] btrfs: disk space caching is enabled
> [ =A0 =A02.697845] dracut: Checking btrfs:
> /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55
> [ =A0 =A02.699999] dracut: trying to mount
> /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55
> [ =A0 =A02.702637] device label Linux data devid 1 transid 611923 /de=
v/sda4
> [ =A0 =A02.704376] btrfs: disk space caching is enabled
> [ =A0 =A03.081720] dracut: btrfs:
> /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55 is clean
> [ =A0 29.934639] dracut: Remounting
> /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55 with -o
> subvolid=3D262,compress=3Dlzo,autodefrag,space_cache,inode_cache,noat=
ime,ro
> [ =A0 29.936810] device label Linux data devid 1 transid 611926 /dev/=
sda4
> [ =A0 29.937720] btrfs: use lzo compression
> [ =A0 29.937726] btrfs: enabling auto defrag
> [ =A0 29.937733] btrfs: enabling inode map caching
> [ =A0 29.937735] btrfs: disk space caching is enabled
> [ =A0 30.388066] dracut: Mounted root filesystem /dev/sda4
> [ =A0 30.461884] dracut: Switching root
> [ =A0 31.241729] udevd[1322]: starting version 182
> [ =A0 31.422905] btrfs: use lzo compression
> [ =A0 31.422909] btrfs: enabling auto defrag
> [ =A0 31.422913] btrfs: enabling inode map caching
> [ =A0 31.422915] btrfs: disk space caching is enabled
>
> vs fast:
> [ =A0 =A00.000000] Linux version 3.3.1 (cwalton@ayu) (gcc version 4.6=
=2E3
> (Exherbo gcc-4.6.3) ) #53 SMP PREEMPT Wed Apr 4 01:20:47 EDT 2012
> [ =A0 =A00.000000] Command line:
> root=3DUUID=3D43969cd0-4aca-4297-bfbe-952a692f7d55
> rootflags=3Dsubvolid=3D262,compress=3Dlzo,autodefrag,space_cache,inod=
e_cache,noatime

Calvin, I noticed that you have the space_cache mount option set. I
remember josef saying that it is a one-time option where it's a
permanent change after mounting for the first time, therefore each
subsequent mount will not require the option. In fact, if the option
is specified again, the space_cache is reset.

Is this still up-to-date info?


> mtrr_chunk_size=3D512M quiet
> <snip>
> [ =A0 =A01.060117] udevd[695]: starting version 182
> [ =A0 =A01.344328] device label Linux data devid 1 transid 611917 /de=
v/sda4
> [ =A0 =A01.384888] dracut: Checking, if btrfs device complete
> [ =A0 =A01.405121] device label Linux data devid 1 transid 611917 /de=
v/sda4
> [ =A0 =A01.405905] btrfs: disk space caching is enabled
> [ =A0 =A01.971953] device label Linux data devid 1 transid 611917 /de=
v/sda4
> [ =A0 =A01.972519] btrfs: use lzo compression
> [ =A0 =A01.972523] btrfs: enabling auto defrag
> [ =A0 =A01.972526] btrfs: enabling inode map caching
> [ =A0 =A01.972528] btrfs: disk space caching is enabled
> [ =A0 =A02.528540] dracut: Checking btrfs:
> /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55
> [ =A0 =A02.530725] dracut: trying to mount
> /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55
> [ =A0 =A02.558285] device label Linux data devid 1 transid 611917 /de=
v/sda4
> [ =A0 =A02.559087] btrfs: disk space caching is enabled
> [ =A0 =A03.013103] dracut: btrfs:
> /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55 is clean
> [ =A0 =A03.518807] dracut: Remounting
> /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55 with -o
> subvolid=3D262,compress=3Dlzo,autodefrag,space_cache,inode_cache,noat=
ime,ro
> [ =A0 =A03.520031] device label Linux data devid 1 transid 611920 /de=
v/sda4
> [ =A0 =A03.520680] btrfs: use lzo compression
> [ =A0 =A03.520684] btrfs: enabling auto defrag
> [ =A0 =A03.520688] btrfs: enabling inode map caching
> [ =A0 =A03.520689] btrfs: disk space caching is enabled
> [ =A0 =A04.066285] dracut: Mounted root filesystem /dev/sda4
> [ =A0 =A04.120861] dracut: Switching root
> [ =A0 =A04.995934] btrfs: use lzo compression
> [ =A0 =A04.995938] btrfs: enabling auto defrag
> [ =A0 =A04.995942] btrfs: enabling inode map caching
> [ =A0 =A04.995943] btrfs: disk space caching is enabled
> [ =A0 =A05.010473] udevd[1330]: starting version 182
>
> --
> Calvin Walton <calvin.walton@kepstin.ca>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
