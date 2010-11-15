From: Heinz Diehl <htd@fritha.org>
Subject: Re: dm-crypt barrier support is effective
Date: Mon, 15 Nov 2010 08:25:45 +0100
Message-ID: <20101115072545.GA7492@fritha.org>
References: <AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com>
 <AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>
 <20101107194547.GA12521@basil.fritz.box>
 <4CD71C8B.1050604@redhat.com>
 <20101107230508.GB17592@basil.fritz.box>
 <20101108145809.GD29714@redhat.com>
 <1289238930-sup-9765@think>
 <20101114205925.GA20451@redhat.com>
 <AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>
 <4CE05A9E.9090204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt <jackdachef@gmail.com>, Mike Snitzer <snitzer@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, Chris Mason <chris.mason@oracle.com>
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CE05A9E.9090204@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 15.11.2010, Milan Broz wrote: 

> even with v5 I sent on Friday?

Your v5 patch applies cleanly to 2.6.36, but fails to build
on my system:

[....]
LD      fs/xfs/xfs.o
LD      fs/xfs/built-in.o
CC      fs/compat_ioctl.o
drivers/md/dm-crypt.c: In function crypt_ctr':
drivers/md/dm-crypt.c:1408: error: WQ_MEM_RECLAIM' undeclared (first use in this function)
drivers/md/dm-crypt.c:1408: error: (Each undeclared identifier is reported only once
drivers/md/dm-crypt.c:1408: error: for each function it appears in.)
make[2]: *** [drivers/md/dm-crypt.o] Error 1
make[1]: *** [drivers/md] Error 2
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....
CC      fs/nfsctl.o
CC      net/netfilter/nf_sockopt.o
[....]
