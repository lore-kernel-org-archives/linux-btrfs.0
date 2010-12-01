From: Milan Broz <mbroz@redhat.com>
Subject: Re: dm-crypt barrier support is effective
Date: Wed, 01 Dec 2010 19:24:17 +0100
Message-ID: <4CF692D1.1010906@redhat.com>
References: <20101107194547.GA12521@basil.fritz.box>	<4CD71C8B.1050604@redhat.com>	<20101107230508.GB17592@basil.fritz.box>	<20101108145809.GD29714@redhat.com>	<1289238930-sup-9765@think>	<20101114205925.GA20451@redhat.com>	<AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>	<4CE05A9E.9090204@redhat.com>	<AANLkTimT0t3xqgKdAn7MBPD7ED-9uPS+WJE0z+K8tciu@mail.gmail.com>	<AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>	<20101201165229.GC13415@redhat.com> <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mike Snitzer <snitzer@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>,
	Chris Mason <chris.mason@oracle.com>, htejun@gmail.com
To: Matt <jackdachef@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/01/2010 06:35 PM, Matt wrote:
> Thanks for pointing to v6 ! I hadn't noticed that there was a new one :)
> 
> Well, so I'll restore my box to a working/productive state and will
> try out v6 (I'm pretty confident that it'll work without problems).

It's the same as previous, just with fixed header (to track it properly
in patchwork) , second patch adds some read optimisation, nothing what
should help here.

Anyway, I run several tests on 2.6.37-rc3+ and see no integrity
problems (using xfs,ext3 and ext4 over dmcrypt).

So please try to check which change causes these problems for you,
it can be something completely unrelated to these patches.

(If if anyone know how to trigger some corruption with btrfs/dmcrypt,
let me know I am not able to reproduce it either.)

Milan
