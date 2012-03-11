From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
Date: Sun, 11 Mar 2012 10:41:50 +0100
Message-ID: <CADDYkjRZZ7H_UnbU9y8GNmA8oMd23ZOwSsbPW5CHOFFz6Vv6Mg@mail.gmail.com>
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
	<20120308155211.GF4334@twin.jikos.cz>
	<CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com>
	<4F595D6D.6080809@cn.fujitsu.com>
	<20120309105537.GG4334@twin.jikos.cz>
	<CADDYkjRcRbxxPErdMBOs55-gNHZA0GfxcsWNrVbAuv37b3rtvw@mail.gmail.com>
	<20120309114010.GH4334@twin.jikos.cz>
	<CADDYkjTsDf0J0v7B-78SiYPsjPsn1VOCbiqAMq8TJxgPc_MiBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, Jacek Luczak <difrost.kernel@gmail.com>,
	Liu Bo <liubo2009@cn.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, josef@redhat.com,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADDYkjTsDf0J0v7B-78SiYPsjPsn1VOCbiqAMq8TJxgPc_MiBg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2012/3/10 Jacek Luczak <difrost.kernel@gmail.com>:
> 2) A *regression* in 3.3.0-rc6-00197-g9f8050c
> - completely unusable as reports ENOSPC
> - to reproduce, mount volume and issue:
> # CNT=3D1 ; while [ $CNT -lt 10000 ] ; do =A0rm -f /btrfs/dd ; ! touc=
h
> /btrfs/dd && echo "$CNT" && break =A0; CNT=3D$(( $CNT + 1 )) ; done
> On my host this shows:
> # CNT=3D1 ; while [ $CNT -lt 10000 ] ; do =A0rm -f /btrfs/dd ; ! touc=
h
> /btrfs/dd && echo "$CNT" && break =A0; CNT=3D$(( $CNT + 1 )) ; done
> touch: cannot touch `/btrfs/dd': No space left on device
> 423
> - remount to reset:
> # CNT=3D1 ; while [ $CNT -lt 10000 ] ; do =A0rm -f /btrfs/dd ; ! touc=
h
> /btrfs/dd && echo "$CNT" && break =A0; CNT=3D$(( $CNT + 1 )) ; done
> touch: cannot touch `/btrfs/dd': No space left on device
> 1
> # umount /btrfs/
> # mount -t btrfs /dev/vg00/btrfs /btrfs/ -o noatime,nodatacow,default=
s
> # CNT=3D1 ; while [ $CNT -lt 10000 ] ; do =A0rm -f /btrfs/dd ; ! touc=
h
> /vdd && echo "$CNT" && break =A0; CNT=3D$(( $CNT + 1 )) ; done
> touch: cannot touch `/btrfs/dd': No space left on device
> 423
> - bisected down to 5500cdb (Btrfs: increase the global block reserve
> estimates). After reverting this one Linus master works for me again.

This patch is included in 3.3-rc7. Do you plan to keep it or revert?

-jacek
