From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: Btrfs for mainline
Date: Tue, 06 Jan 2009 01:43:08 +0900 (JST)
Message-ID: <20090106.014308.37731373.ryusuke@osrg.net>
References: <1230925087.7538.41.camel@think.oraclecorp.com>
	<20090103.184406.54858118.ryusuke@osrg.net>
	<1231164896.4290.19.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Cc: konishi.ryusuke@lab.ntt.co.jp, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231164896.4290.19.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 05 Jan 2009 09:14:56 -0500, Chris Mason <chris.mason@oracle.com> wrote:
> On Sat, 2009-01-03 at 18:44 +0900, Ryusuke Konishi wrote:
> > On Fri, 02 Jan 2009 14:38:07 -0500, Chris Mason 
> >
> > Btrfs seems to have other helpful code including pages/bio compression
> > which may become separable, too.  And, this may be the same for
> > pages/bio encryption/decryption code which would come next.  (I don't
> > mention about the volume management/raid feature here to avoid getting
> > off the subject, but it's likewise).
> > 
> 
> The compression code is somewhat tied to the btrfs internals, but it
> could be pulled out without too much trouble.  The big question there is
> if other filesystems are interested in transparent compression support.

It was so attractive to me ;)
though I don't know if it's applicable.

Anyway, making this common can be said to be the exercise of someone
who try to reuse it, and I don't adhere to it in order not to get off
the subject.  Just I wanted to add presence of other candicates.

> But, at the end of the day, most of the work is still done by the zlib
> code.  The btrfs bits just organize pages to send down to zlib.
> 
> -chris

Yes, but that's the interesting point; it provides ways to apply
compression through array of pages, or bio - I like it.

Ryusuke
