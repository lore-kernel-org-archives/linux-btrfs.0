From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Notes on support for multiple devices for a single filesystem
Date: Wed, 17 Dec 2008 22:20:56 +0100
Message-ID: <ac3eb2510812171320i414d89d4x9840954275774d51@mail.gmail.com>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	 <1228962896.21376.11.camel@think.oraclecorp.com>
	 <20081211141436.030c2d65.sfr@canb.auug.org.au>
	 <20081210200604.8e190b0d.akpm@linux-foundation.org>
	 <1229006596.22236.46.camel@think.oraclecorp.com>
	 <20081215210323.GB5000@webber.adilger.int>
	 <20081217132343.GA14695@infradead.org>
	 <20081217115325.3312858a.akpm@linux-foundation.org>
	 <1229547485.27170.77.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"Christoph Hellwig" <hch@infradead.org>, adilger@sun.com,
	sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1229547485.27170.77.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 17, 2008 at 21:58, Chris Mason <chris.mason@oracle.com> wrote:
> On Wed, 2008-12-17 at 11:53 -0800, Andrew Morton wrote:

>> One thing I've never seen comprehensively addressed is: why do this in
>> the filesystem at all?  Why not let MD take care of all this and
>> present a single block device to the fs layer?
>>
>> Lots of filesystems are violating this, and I'm sure the reasons for
>> this are good, but this document seems like a suitable place in which to
>> briefly decribe those reasons.
>
> I'd almost rather see this doc stick to the device topology interface in
> hopes of describing something that RAID and MD can use too.  But just to
> toss some information into the pool:
>
> * When moving data around (raid rebuild, restripe, pvmove etc), we want
> to make sure the data read off the disk is correct before writing it to
> the new location (checksum verification).
>
> * When moving data around, we don't want to move data that isn't
> actually used by the filesystem.  This could be solved via new APIs, but
> keeping it crash safe would be very tricky.
>
> * When checksum verification fails on read, the FS should be able to ask
> the raid implementation for another copy.  This could be solved via new
> APIs.
>
> * Different parts of the filesystem might want different underlying raid
> parameters.  The easiest example is metadata vs data, where a 4k
> stripesize for data might be a bad idea and a 64k stripesize for
> metadata would result in many more rwm cycles.
>
> * Sharing the filesystem transaction layer.  LVM and MD have to pretend
> they are a single consistent array of bytes all the time, for each and
> every write they return as complete to the FS.
>
> By pushing the multiple device support up into the filesystem, I can
> share the filesystem's transaction layer.  Work can be done in larger
> atomic units, and the filesystem will stay consistent because it is all
> coordinated.
>
> There are other bits and pieces like high speed front end caching
> devices that would be difficult in MD/LVM, but since I don't have that
> coded yet I suppose they don't really count...

Features like the very nice and useful directory-based snapshots would
also not be possible with simple block-based multi-devices, right?

Kay
