From: Sander <sander@humilis.net>
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 22:40:36 +0200
Message-ID: <20110506204036.GA7877@attic.humilis.net>
References: <201105031227.43619.CACook@quantum-sci.com>
 <201105060815.26395.CACook@quantum-sci.com>
 <201105061009.29756.CACook@quantum-sci.com>
 <201105061304.28903.CACook@quantum-sci.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105061304.28903.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

CACook@quantum-sci.com wrote (ao):
> > Wow.  I was very nearly completely screwed.  I went ahead and
> > rebooted, but grub.cfg was not set up at all.  I had no way to run
> > update-grub on that root, and so tried manually filling in the
> > missing parameters.  That didn't work, probably through the
> > obfuscation of UUIDs I couldn't determine what was really going on.
> > What a terrible idea the way they were implemented, UUIDs.  Why not
> > put the current device assignment somewhere in the number?
> > Terrible.

That would kinda defeat the purpose :p

> > I ended up copying an old grub.cfg from a backup, and that got me at
> > least booted, though with lots of grub errors.  Now I am at a loss.

What errors ..

> > I don't understand this.  grub-update at least -pretended- to work
> > before I rebooted.  I am still in shock.  MUST get some actual work
> > done today, rather than bit-twiddling.  MUST try and make a living.

Dude, really ..

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
