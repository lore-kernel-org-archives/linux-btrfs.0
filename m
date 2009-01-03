From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: Btrfs for mainline
Date: Sat, 03 Jan 2009 18:44:06 +0900 (JST)
Message-ID: <20090103.184406.54858118.ryusuke@osrg.net>
References: <1230765549.7538.8.camel@think.oraclecorp.com>
	<20090103.013755.42849152.ryusuke@osrg.net>
	<1230925087.7538.41.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1230925087.7538.41.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 02 Jan 2009 14:38:07 -0500, Chris Mason <chris.mason@oracle.com> wrote:
> On Sat, 2009-01-03 at 01:37 +0900, Ryusuke Konishi wrote:
> > In addition, there seem to be well-separated reusable routines such as
> > async-thread (enhanced workqueue) and extent_map.  Do you intend to
> > move these into lib/ or so?
> 
> Sorry, looks like I hit send too soon that time.  The async-thread code
> is very self contained, and was intended for generic use.  Pushing that
> into lib is probably a good idea.

As for async-thread, kernel/ seems to be better place (sorry, I also hit
send too soon ;)

Anyway, I think it should be reviewed deeply by scheduler people and
wider range of people.  So, it's a good idea to put it out in order to
arouse interest.
 
> The extent_map and extent_buffer code was also intended for generic use.
> It needs some love and care (making it work for blocksize != pagesize)
> before I'd suggest moving it out of fs/btrfs.
> 
> -chris

The extent_map itself seemed independent of the problem to me, but I
understand your plan.

Btrfs seems to have other helpful code including pages/bio compression
which may become separable, too.  And, this may be the same for
pages/bio encryption/decryption code which would come next.  (I don't
mention about the volume management/raid feature here to avoid getting
off the subject, but it's likewise).

I think it's wonderful if they can be well-integrated into sublayers
or libraries.

Regards,
Ryusuke
