From: Yan Zheng <yanzheng@21cn.com>
Subject: Re: Read errors while benchmarking
Date: Thu, 18 Jun 2009 17:23:01 +0800
Message-ID: <3d0408630906180223l7dc509c4s440fc666c8a2b1bc@mail.gmail.com>
References: <q6apg6-5d2.ln1@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <q6apg6-5d2.ln1@phenom2.trippelsdorf.de>
List-ID: <linux-btrfs.vger.kernel.org>

2009/6/18 Markus Trippelsdorf <markus@trippelsdorf.de>:
> I'm running the latest git kernel and git btrfs-progs.
> When I try to run some benchmarks on my btrfs partition I always get
> read errors:
>
> phenom2 ~ # iozone -I -a -s 100M -r 4k -i 0 -i 1 -i 2
> =A0 =A0 =A0 =A0Iozone: Performance Test of File I/O
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Version $Revision: 3.321 $
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Compiled for 64 bit mode.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Build: linux-AMD64
>
> =A0 =A0 =A0 =A0Contributors:William Norcott, Don Capps, Isom Crawford=
, Kirby Collins
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Al Slater, Scott Rhine, Mike =
Wisner, Ken Goss
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Steve Landherr, Brad Smith, M=
ark Kelly, Dr. Alain CYR,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Randy Dunlap, Mark Montague, =
Dan Million, Gavin Brebner,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Jean-Marc Zucconi, Jeff Blomb=
erg, Benny Halevy,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Erik Habbinga, Kris Strecker,=
 Walter Wong, Joshua Root.
>
> =A0 =A0 =A0 =A0Run began: Thu Jun 18 10:18:06 2009
>
> =A0 =A0 =A0 =A0O_DIRECT feature enabled
> =A0 =A0 =A0 =A0Auto Mode
> =A0 =A0 =A0 =A0File size set to 102400 KB
> =A0 =A0 =A0 =A0Record Size 4 KB
> =A0 =A0 =A0 =A0Command line used: iozone -I -a -s 100M -r 4k -i 0 -i =
1 -i 2
> =A0 =A0 =A0 =A0Output is in Kbytes/sec
> =A0 =A0 =A0 =A0Time Resolution =3D 0.000001 seconds.
> =A0 =A0 =A0 =A0Processor cache size set to 1024 Kbytes.
> =A0 =A0 =A0 =A0Processor cache line size set to 32 bytes.
> =A0 =A0 =A0 =A0File stride size set to 17 * record size.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0random =A0random =A0 =A0=
bkwd =A0 record =A0 stride
> =A0 =A0 =A0 =A0 =A0 =A0 =A0KB =A0reclen =A0 write rewrite =A0 =A0read=
 =A0 =A0reread =A0 =A0read =A0 write =A0 =A0read =A0rewrite =A0 =A0 rea=
d =A0 fwrite frewrite =A0 fread =A0freread
> =A0 =A0 =A0 =A0 =A0102400 =A0 =A0 =A0 4 =A0 =A07540 =A0 =A05981
> Error reading block 0 ef000000
> read: Invalid argument
>
> phenom2 /tmp # sysbench =A0--file-extra-flags=3Ddirect =A0--num-threa=
ds=3D16 --test=3Dfileio --file-total-size=3D100M --file-test-mode=3Drnd=
rd prepare =A0 =A0 =A0 =A0 =A0 =A0 sysbench 0.4.10: =A0multi-threaded s=
ystem evaluation benchmark
>
> 128 files, 800Kb each, 100Mb total
> Creating files for the test...
> phenom2 /tmp # sysbench =A0--file-extra-flags=3Ddirect =A0--num-threa=
ds=3D16 --test=3Dfileio --file-total-size=3D100M --file-test-mode=3Drnd=
rd run
> sysbench 0.4.10: =A0multi-threaded system evaluation benchmark
>
> Running the test with following options:
> Number of threads: 16
>
> Extra file open flags: 16384
> 128 files, 800Kb each
> 100Mb total file size
> Block size 16Kb
> Number of random requests for random IO: 10000
> Read/Write ratio for combined random IO test: 1.50
> Periodic FSYNC enabled, calling fsync() each 100 requests.
> Calling fsync() at the end of test, Enabled.
> Using synchronous I/O mode
> Doing random read test
> Threads started!
> FATAL: Failed to read file! file: 3 pos: 196608 errno =3D 22 ()
> FATAL: Failed to read file! file: 13 pos: 524288 errno =3D 22 ()
> FATAL: Failed to read file! file: 48 pos: 180224 errno =3D 22 ()
> FATAL: Failed to read file! file: 96 pos: 262144 errno =3D 22 ()
> FATAL: Failed to read file! file: 26 pos: 311296 errno =3D 22 ()
> FATAL: Failed to read file! file: 26 pos: 507904 errno =3D 22 ()
> FATAL: Failed to read file! file: 127 pos: 589824 errno =3D 22 ()
> FATAL: Failed to read file! file: 3 pos: 0 errno =3D 22 ()
> FATAL: Failed to read file! file: 119 pos: 262144 errno =3D 22 ()
> FATAL: Failed to read file! file: 9 pos: 688128 errno =3D 22 ()
> FATAL: Failed to read file! file: 62 pos: 557056 errno =3D 22 ()
> FATAL: Failed to read file! file: 87 pos: 655360 errno =3D 22 ()
> FATAL: Failed to read file! file: 113 pos: 425984 errno =3D 22 ()
> FATAL: Failed to read file! file: 20 pos: 344064 errno =3D 22 ()
> FATAL: Failed to read file! file: 17 pos: 294912 errno =3D 22 ()
> FATAL: Failed to read file! file: 16 pos: 0 errno =3D 22 ()
> Done.
>

Currently, btrfs doesn't support using direct I/O for read.

Yan
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
