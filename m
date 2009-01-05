From: "Ryusuke Konishi" <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH] Btrfs: fix build errors of extent_io.c
Date: Tue, 6 Jan 2009 02:48:56 +0900
Message-ID: <c4a7c9420901050948l2e4f782eja83d8d6bc4b78814@mail.gmail.com>
References: <20081224.175640.119553873.ryusuke@osrg.net>
	 <1231170459.4290.90.camel@think.oraclecorp.com>
	 <c4a7c9420901050929q37f4b640wdebad72fe227e456@mail.gmail.com>
	 <20090105173734.GA32436@infradead.org>
	 <1231177160.4290.139.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Christoph Hellwig" <hch@infradead.org>,
	linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231177160.4290.139.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

2009/1/6 Chris Mason <chris.mason@oracle.com>:
> On Mon, 2009-01-05 at 12:37 -0500, Christoph Hellwig wrote:
>> On Tue, Jan 06, 2009 at 02:29:17AM +0900, Ryusuke Konishi wrote:
>> > 2009/1/6 Chris Mason <chris.mason@oracle.com>:
>> > > On Wed, 2008-12-24 at 17:56 +0900, Ryusuke Konishi wrote:
>> > >> Hi Chris,
>> > >>
>> > >> I've started to read and try btrfs, and soon met the following build
>> > >> errors.  The attached patch fixes the problem.
>> > >>
>> > >> Could you check this?
>> > >>
>> > >
>> > > Strange, I wonder why your gcc complains and mine doesn't ;)  I'll fix
>> > > these up thouhg.
>> >
>> > Because I tried it on a powerpc ;)
>> > The check of EXPORT_SYMBOL macros seems to be more strict
>> > than that of x86.
>>
>> It doesn't really matter how strict the checks are, because the exports
>> simply need to go away.  As long as the extent_map/buffer code resides
>> inside btrfs no one should be using it without either copying it or
>> moving it out of the btrfs module and into a common one first.
>
> Yes, my plan was to drop the exports.
>
> -chris

I agree with it, too.
The patch was just to let you know the problem at the time of
Chrismas.

Ryusuke
