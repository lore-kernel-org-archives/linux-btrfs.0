From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: converting one-disk btrfs into RAID-1?
Date: Tue, 12 Oct 2010 11:59:10 +0200
Message-ID: <20101012095910.GA18076@mother.pipebreaker.pl>
References: <4CB2FF03.8090608@wpkg.org>
 <m3ocb0irqj.fsf@pullcord.laptop.org>
 <i919v8$n91$1@dough.gmane.org>
 <20101012093431.GC30730@mother.pipebreaker.pl>
 <20101012094935.GA2338@selene>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101012094935.GA2338@selene>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 12, 2010 at 10:49:35AM +0100, Hugo Mills wrote:
> On Tue, Oct 12, 2010 at 11:34:31AM +0200, Tomasz Torcz wrote:
> > On Tue, Oct 12, 2010 at 11:32:07AM +0200, David Brown wrote:
> > > Is it possible to view the raid levels of data and meta data for an
> > > existing btrfs filesystem?  It's easy to pick them when creating the
> > > system, but I couldn't find any way to view them afterwards.
> > 
> >   "btrfs f df" will show them, except for few kernel releases when the ioctl()
> > was broken.
> 
>    Umm...
> 
> hrm@vlad:~ $ sudo btrfs fi df /mnt/
> [sudo] password for hrm: 
> Data: total=303.01GB, used=302.16GB
> Metadata: total=3.01GB, used=476.77MB
> System: total=11.88MB, used=36.00KB
> 
>    This is the latest btrfs git kernel and tools. What should I be
> seeing here?

 Do you have this patch applied?
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg06239.html

-- 
Tomasz Torcz                                                       72->|   80->|
xmpp: zdzichubg@chrome.pl                                          72->|   80->|

