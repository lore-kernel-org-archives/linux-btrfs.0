From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: converting one-disk btrfs into RAID-1?
Date: Tue, 12 Oct 2010 11:34:31 +0200
Message-ID: <20101012093431.GC30730@mother.pipebreaker.pl>
References: <4CB2FF03.8090608@wpkg.org>
 <m3ocb0irqj.fsf@pullcord.laptop.org>
 <i919v8$n91$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <i919v8$n91$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 12, 2010 at 11:32:07AM +0200, David Brown wrote:
> On 11/10/2010 19:06, Chris Ball wrote:
> >Hi,
> >
> >    >  Is it possible to turn a 1-disk (partition) btrfs filesystem into
> >    >  RAID-1?
> >
> >Not yet, but I'm pretty sure it's on the roadmap.
> >
> >- Chris.
> 
> Is it possible to view the raid levels of data and meta data for an
> existing btrfs filesystem?  It's easy to pick them when creating the
> system, but I couldn't find any way to view them afterwards.

  "btrfs f df" will show them, except for few kernel releases when the ioctl()
was broken.

-- 
Tomasz Torcz                                                       72->|   80->|
xmpp: zdzichubg@chrome.pl                                          72->|   80->|

