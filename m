From: btrfs@think-future.com
Subject: loop-mount btrfs .19 w/ 2.6.30: btrfs: open_ctree failed
Date: Wed, 22 Jul 2009 12:30:04 +0200
Message-ID: <20090722103003.GC16472@localhost>
Reply-To: btrfs@think-future.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

Just tried to mount a btrfs 0.19 in a image file:

dd if=/dev/zero of=btrfs-play.img bs=1024k count=256

losetup -f btrfs-play.img
losetup -a
/dev/loop0: [fd02]:24653 (btrfs-play.img)

mkfs.btrfs -L BTRFStest /dev/loop0

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label BTRFStest on /dev/loop0
        nodesize 4096 leafsize 4096 sectorsize 4096 size 256.00MB
Btrfs Btrfs v0.19

btrfsctl -A /dev/loop0
operation complete
Btrfs Btrfs v0.19

mount -t btrfs /dev/loop0 btrfs-test/
mount: tipo fs errato, opzione non valida, superblocco su /dev/loop0 danneggiato,
       codepage o programma ausiliario mancante, o altro errore
        In alcuni casi si possono trovare informazioni utili in syslog. Provare
       ad esempio 'dmesg | tail'

dmesg | tail
[140443.202115] device label BTRFS_mypole devid 1 transid 7 /dev/loop0
[140443.202369] BTRFS: couldn't mount because of unsupported optional features (1).
[140443.202480] btrfs: open_ctree failed

Did I miss something? Using ext3/4 the above works flawlessly..

Probably it's only due to the "open_ctree" problem above. Using kernel 2.6.30 and btrfs-tools 19-2 (debian).

Any hints?

Thanks.
