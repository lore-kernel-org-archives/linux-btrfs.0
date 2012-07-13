Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34313 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2GMOit convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jul 2012 10:38:49 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Can't mount, power failure - recoverable?
Date: Fri, 13 Jul 2012 16:38:34 +0200
Cc: Hugo Mills <hugo@carfax.org.uk>, Skylar Burtenshaw <daninfuchs@gmail.com>
References: <loom.20120317T051243-551@post.gmane.org> <201207131423.54019.Martin@lichtvoll.de> <20120713122839.GJ28701@carfax.org.uk> (sfid-20120713_143222_885648_8598A33F)
In-Reply-To: <20120713122839.GJ28701@carfax.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201207131638.34771.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 13. Juli 2012 schrieb Hugo Mills:
> On Fri, Jul 13, 2012 at 02:23:53PM +0200, Martin Steigerwald wrote:
> > Am Montag, 26. März 2012 schrieb Skylar Burtenshaw:
> > > Fajar A. Nugraha <list <at> fajar.net> writes:
> > > > Didn't Chris' last response basically say "use kernel 3.2 or
> > > > newer, mount the fs (possibly with -o ro), and copy the data
> > > > elsewhere"?
> > > 
> > > Why yes, yes it did actually. I appreciate your spotlighting it,
> > > just in case I somehow managed to miss it, though.
> > > 
> > > > Have you done that?
> > > 
> > > I have. In fact, in my first message, I stated that in all kernels
> > > up to present 3.2 kernels, I get several minutes of disk churning,
> > > then a stack trace. Also present in my messages is the fact that
> > > the filesystem will not mount, as well as data output from the
> > > recovery program etc which fail to recognize things in the
> > > filesystem that they require in order to fix it. Did you have
> > > something you wished to suggest, in order to help me? If so, I'd
> > > gladly listen to any proposed ideas.
> > 
> > Since I didn´t found any explicit mention on it:
> > 
> > Did you try btrfs-zero-log on the partition prior to mounting it?
> > 
> > All of my BTRFS will not mount after sudden write interruption cases
> > have been solved by it. Except one with a BTRFS RAID 0 with lots of
> > 2 TB drives at a time where I didn´t know about btrfs-zero-log.
> > Maybe it would have helped there, too.
> > 
> > Of course I could be completely off track and this could be a
> > completely different issue.
> 
>    I'm afraid you probably are -- there's nothing I can see in the
> stack trace that would indicate that it's falling over in the log tree
> replay, which is the only thing that btrfs-zero-log would help with.

Yes.

But why would it write some stuff then on mounting?

Could it be that it tries to update some of its caches (inode or space)? 
But then that also does not seem to be in the trace.

Well I bet I leave that to you BTRFS developers then. Just wanted to throw 
in some ideas.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
