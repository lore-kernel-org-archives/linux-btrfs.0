From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [MeeGo-dev] Btrfs as default file system
Date: Tue, 11 May 2010 09:18:44 -0400
Message-ID: <20100511131844.GB27606@think>
References: <1273575646.2336.9.camel@sanganak>
 <4BE95584.7000204@linux.intel.com>
 <1273583736.2336.105.camel@sanganak>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext Arjan van de Ven <arjan@linux.intel.com>,
	"meego-dev@meego.com" <meego-dev@meego.com>,
	linux-btrfs@vger.kernel.org
To: Ameya Palande <ameya.palande@nokia.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1273583736.2336.105.camel@sanganak>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 11, 2010 at 04:15:36PM +0300, Ameya Palande wrote:
> Hi Arjan,
> 
> On Tue, 2010-05-11 at 15:03 +0200, ext Arjan van de Ven wrote:
> > On 5/11/2010 4:00, Ameya Palande wrote:
> > > Hi,
> > >
> > > I wanted to know why Btrfs is selected as default file system for MeeGo.
> > > Following text is copied from Btrfs kernel Kconfig option:
> > >
> > > Btrfs filesystem (EXPERIMENTAL) Unstable disk format
> > 
> > the Kconfig text is out of date.
> 
> Thanks for the information :)
> 
> I am CCing this to linux-btrfs so that someone can take a look at this
> text and fix this for 2.6.34 release.
> 
> Can someone update the btrfs kconfig text which says that this file
> system is experimental and on disk format is not yet finalized?

Hi everyone,

It is too late for such a change in 2.6.34, Linus announced the final RC
this week.  But I'll have this queued in my .35 releases.

If meego would like to include a patch for this in their kernel, I'd be
happy to send it along.

-chris

