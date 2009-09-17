From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: btrfs csum failed on git .pack file
Date: Thu, 17 Sep 2009 07:05:12 +0200
Message-ID: <20090917050512.GB1916@phenom2.trippelsdorf.de>
References: <20090907203531.GA1889@phenom2.trippelsdorf.de>
 <20090908200041.GF18599@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090908200041.GF18599@kernel.dk>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 08, 2009 at 10:00:42PM +0200, Jens Axboe wrote:
> On Mon, Sep 07 2009, Markus Trippelsdorf wrote:
> > Just got this error today in my dmesg:
> > btrfs csum failed ino 1483065 off 158482432 csum 4283543305 private 43905798
> > 
> > linux % find . -inum 1483065
> > ./.git/objects/pack/pack-f9251bcc6a8afe3c92193e14d1d742f2f0182ce5.pack
> > 
> > It's the main pack file from my git linux kernel tree:
> > 
> > linux % ls -l ./.git/objects/pack/
> > total 562848
> > -rw-r--r-- 1 markus markus   1891324 2008-11-29 19:49 pack-011b43fa6956667db5e67fba859e40cb4b154226.idx
> > -rw-r--r-- 1 markus markus  44002938 2008-11-29 19:54 pack-011b43fa6956667db5e67fba859e40cb4b154226.pack.temp
> > -rw-r--r-- 1 markus markus    730332 2008-11-29 19:49 pack-67be92b3fab3dab175683582dab0b719517e55a5.idx
> > -r--r--r-- 1 markus markus  36061684 2009-09-06 21:48 pack-f9251bcc6a8afe3c92193e14d1d742f2f0182ce5.idx
> > -r--r--r-- 1 markus markus 335202742 2009-09-06 21:48 pack-f9251bcc6a8afe3c92193e14d1d742f2f0182ce5.pack
> > -rw------- 1 markus markus 158457856 2009-09-07 22:15 tmp_pack_OUdxER
> > 
> > I'm running the latest git kernel and I've been using btrfs as my root
> > fs for the last few weeks without problems so far.
> 
> Hmm, I ran into something very similar. Care to check what the corrupted
> block of data looks like (and how big it is)?

I've hit the same problem again today:

btrfs csum failed ino 1826333 off 150208512 csum 4148434891 private 1660028275

The file in question is:
./.git/objects/pack/pack-a2330b703d5a7fd62626b39a5fdfb6eecf739d0d.pack

I can't read the file directly, because of the csum mismatch:

08F3FF80   58 C8 18 3D  36 58 B0 B0  CC 35 3A 3D  72 95 8E 71  9E AA 34 14  0B C4 B4 41  5F E0 6F 66  03 B9 0B 79  X..=6X...5:=r..q..4....A_.of...y
08F3FFA0   9C 94 6B 15  F9 CA 93 AC  C4 34 6E 2C  FA 4C 99 31  55 35 36 3B  46 04 71 7E  2E 66 21 1C  89 FC 1B 92  ..k......4n,.L.1U56;F.q~.f!.....
08F3FFC0   90 FE B2 4D  0D 28 A9 3F  CC D8 B1 9A  38 28 51 86  10 69 88 CA  46 A6 07 FE  EC 0F 2B 7E  81 65 30 86  ...M.(.?....8(Q..i..F.....+~.e0.
08F3FFE0   8E 2A 37 E9  88 CC 6F 1A  8D CF 82 7C  9D 43 A5 B1  FF 2C 62 72  2E 06 E6 44  44 02 45 03  BC 12 EA 3B  .*7...o....|.C...,br...DD.E....;
08F40000

where 0x8F40000=150208512.

# hdparm --fibmap /usr/src/linux/.git/objects/pack/pack-a2330b703d5a7fd62626b39a5fdfb6eecf739d0d.pack
0,13: device not found in /dev

does not work unfortunately. How do I get the LBAs of the file instead?

I did a hex-search on the raw devive with hexedit for 
"90FEB24D0D28A93FCCD8B19A38285186106988CA46A607FEEC0F2B7E81653086", but
there is no obvious corruption in the vicinity of the few places that are
found.

-- 
Markus
