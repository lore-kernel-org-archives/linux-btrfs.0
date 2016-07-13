Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbcGMNTu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 09:19:50 -0400
Date: Wed, 13 Jul 2016 15:19:38 +0200
From: David Sterba <dsterba@suse.cz>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: FIDEDUPERANGE with src_length == 0
Message-ID: <20160713131938.GK10595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160712003537.GA27653@vader.dhcp.thefacebook.com>
 <20160713052643.GD13625@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160713052643.GD13625@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 12, 2016 at 10:26:43PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 11, 2016 at 05:35:37PM -0700, Omar Sandoval wrote:
> > Hey, Darrick,
> > 
> > generic/182 is failing on Btrfs for me with the following output:
> > 
> > --- tests/generic/182.out       2016-07-07 19:51:54.000000000 -0700
> > +++ /tmp/fixxfstests/xfstests/results//generic/182.out.bad      2016-07-11 17:28:28.230039216 -0700
> > @@ -1,12 +1,10 @@
> >  QA output created by 182
> >  Create the original files
> > -dedupe: Extents did not match.
> >  f4820540fc0ac02750739896fe028d56  TEST_DIR/test-182/file1
> >  69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-182/file2
> >  69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-182/file2.chk
> >  Compare against check files
> >  Make the original file almost dedup-able
> > -dedupe: Extents did not match.
> >  f4820540fc0ac02750739896fe028d56  TEST_DIR/test-182/file1
> >  158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-182/file2
> >  158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-182/file2.chk
> > 
> > It looks like that test is checking that a dedupe with length == 0 is
> > treated as a dedupe to EOF, but Btrfs doesn't do that [1]. As far as I
> > can tell, it never did, but maybe I'm just confused. What was the
> > behavior when you introduced that test? That seems like a reasonable
> > thing to do, but I wanted to clear this up before changing/fixing Btrfs.
> 
> It's a shortcut that we're introducing in the upcoming XFS implementation,
> since it shares the same back end as clone/clonerange, which both have
> this behavior.

The support for zero length does not seem to be mentioned anywhere with
the dedupe range ioctl [1], so the current implemetnation is "up to
spec". That it should be valid is hidden in clone_verify_area where a
zero length is substituted with OFFSET_MAX

http://lxr.free-electrons.com/source/fs/read_write.c#L1607

So it looks like it's up to the implementation in the filesystem to
handle that. As the btrfs ioctl was extent-based, a zero length extent
does not make sense, so this case was not handled. But in your patch

2b3909f8a7fe94e0234850aa9d120cca15b6e1f7
btrfs: use new dedupe data function pointer

it was suddenly expected to work. So the missing bits are either 'not
supported' for zero length or actually implement iteration over the
whole file.

[1] https://www.mankier.com/2/ioctl_fideduperange
