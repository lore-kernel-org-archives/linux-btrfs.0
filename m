From: Heinz Diehl <htd@fritha.org>
Subject: Re: dm-crypt barrier support is effective
Date: Wed, 1 Dec 2010 20:59:39 +0100
Message-ID: <20101201195939.GA6491@fritha.org>
References: <20101108145809.GD29714@redhat.com>
 <1289238930-sup-9765@think>
 <20101114205925.GA20451@redhat.com>
 <AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>
 <4CE05A9E.9090204@redhat.com>
 <AANLkTimT0t3xqgKdAn7MBPD7ED-9uPS+WJE0z+K8tciu@mail.gmail.com>
 <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
 <20101201165229.GC13415@redhat.com>
 <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt <jackdachef@gmail.com>, Mike Snitzer <snitzer@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>,
	Chris Mason <chris.mason@oracle.com>, htejun@gmail.com
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CF692D1.1010906@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01.12.2010, Milan Broz wrote: 

> Anyway, I run several tests on 2.6.37-rc3+ and see no integrity
> problems (using xfs,ext3 and ext4 over dmcrypt).

Not that this might help, but just for testing purposes, I have run all 
the -rcX from 2.6.36 on with Milan's patch (XFS filesystem) under heavy 
load and disk i/o, and have not encountered a single problem or corruption.

