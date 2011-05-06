From: CACook@quantum-sci.com
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 13:04:28 -0700
Message-ID: <201105061304.28903.CACook@quantum-sci.com>
References: <201105031227.43619.CACook@quantum-sci.com> <201105060815.26395.CACook@quantum-sci.com> <201105061009.29756.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105061009.29756.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>


Anyone here?


On Friday 6 May, 2011 10:09:29 CACook@quantum-sci.com wrote:
> On Friday 6 May, 2011 08:15:25 CACook@quantum-sci.com wrote:
> > I'm afraid to reboot though, because yesterday I started a btrfs fi balance on this machine while sshed to another, and that is still running 15 hours later with no indication of progress nor sign of abating.  ^C is ineffective.
> 
> Wow.  I was very nearly completely screwed.  I went ahead and rebooted, but grub.cfg was not set up at all.  I had no way to run update-grub on that root, and so tried manually filling in the missing parameters.  That didn't work, probably through the obfuscation of UUIDs I couldn't determine what was really going on.  What a terrible idea the way they were implemented, UUIDs.  Why not put the current device assignment somewhere in the number?  Terrible.
> 
> I ended up copying an old grub.cfg from a backup, and that got me at least booted, though with lots of grub errors.  Now I am at a loss.
> 
> I don't understand this.  grub-update at least -pretended- to work before I rebooted.  I am still in shock.  MUST get some actual work done today, rather than bit-twiddling.  MUST try and make a living.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
