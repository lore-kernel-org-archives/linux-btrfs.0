From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Add Documentation/filesystem/btrfs.txt, remove old
 COPYING and INSTALL
Date: Wed, 07 Jan 2009 09:12:21 -0500
Message-ID: <1231337541.27813.0.camel@think.oraclecorp.com>
References: <1231320915.30643.32.camel@macbook.infradead.org>
	 <ac3eb2510901070545q1a7e4f75s920276640ca6a525@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: David Woodhouse <dwmw2@infradead.org>, linux-btrfs@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510901070545q1a7e4f75s920276640ca6a525@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-01-07 at 14:45 +0100, Kay Sievers wrote:
> On Wed, Jan 7, 2009 at 10:35, David Woodhouse <dwmw2@infradead.org> wrote:
> > Lifted the first paragraphs of btrfs.txt straight from the wiki...
> 
> > +debug-tree: print all of the FS metadata in text form.  Example:
> 
> Can we please rename that tool and prefix everything with btrfs*,
> before anything gets merged into mainline. It's really annoying to
> have specialized tools with completely generic names packaged.
> 
> Ext2 did the same with "debugfs", now we would get a "debug-tree". :)
> 

The tool isn't in mainline, but yes, I'll rename it ;)

-chris


