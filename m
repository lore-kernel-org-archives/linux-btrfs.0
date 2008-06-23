From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: HP opensourced advfs from tru64 and what it means for btrfs
Date: Mon, 23 Jun 2008 18:50:26 +0400
Message-ID: <20080623145026.GA13310@2ka.mipt.ru>
References: <c24352ca0806230737g287de15bv5916d1c7501f06be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: jeffschroeder@computer.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c24352ca0806230737g287de15bv5916d1c7501f06be@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

On Mon, Jun 23, 2008 at 07:37:32AM -0700, Jeff Schroeder (jeffschroed@gmail.com) wrote:
> http://advfs.sourceforge.net/ HP open sourced the advfs filesystem
> from tru64 Unix today under the gplv2.

...
 
> Would it make sense to look at using any of the code from this in
> btrfs, or would it be easier to
> re-implement it all over again? Even though filesystems ported from
> other Posix operating systems to Linux (Ever looked at XFS code)
> can be ugly, this might be a way to accelerate btrfs development.
> If nothing else, it might be interesting to see how HP solved problems
> btrfs will soon be solving.

Sure it is interesting as studing anything new, but there is nothing in
advfs which can prevent btrfs from success. Virtually nothing.
Advfs is quite old technology built on top of almost 20 years old ideas
and hardware, while the former can still be (and likely is) valid,
hardware made significant progress. Also transaction log approach can
be very slow in lots of cases. I'm not sure using advfs code is ever
possible in btrfs: they are completely different filesystems, which
share mostly only ideas on what end user may or may not want to have.
Also having own new code is better from lots of viewpoints: from time
spent to write vs time to understand, from understandability of some
internal features and so on.

> Don't drink and derive, alcohol and analysis don't mix.
> http://www.digitalprognosis.com

Depending on analysis type :)

-- 
	Evgeniy Polyakov
