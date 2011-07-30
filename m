From: CACook@quantum-sci.com
Subject: Re: Emergency - Can't Boot
Date: Sat, 30 Jul 2011 14:12:46 -0700
Message-ID: <201107301412.46941.CACook@quantum-sci.com>
References: <1312055511.4346.9.camel@hydra.darkmatter.org> <20110730204621.GA6989@carfax.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110730204621.GA6989@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 30 July, 2011 13:46:21 Hugo Mills wrote:
> On Sat, Jul 30, 2011 at 12:51:51PM -0700, . wrote:
> > I just did my monthly dist-upgrade and rebooted, only to have it stall
> > at Control D.  It tried to automatically run fsck.btrfs and of course it
> > failed, and insists that I run it manually.  I can't.  I've rebooted
> > several times and can't get past Control D.  Don't know where it keeps
> > track of the number of reboots since last fsck.
> > 
> > What do you do in a case like this?
> 
>    [Just a note -- this seems to have been fixed in a conversation on
> IRC, by linking /bin/true to /bin/fsck.btrfs]

Yes that fixed it.

