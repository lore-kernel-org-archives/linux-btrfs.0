From: Chris Mason <chris.mason@oracle.com>
Subject: Re: questions about GRUB and BTRFS
Date: Wed, 25 Feb 2009 15:22:23 -0500
Message-ID: <1235593343.32346.73.camel@think.oraclecorp.com>
References: <a3a222ba714187fedfe43fe9f7086242@smtp.arbitraryconstant.com>
	 <1235586140.32346.37.camel@think.oraclecorp.com>
	 <6e246ee64cdb6decfd7153436888efcb@smtp.arbitraryconstant.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linux btrfs <linux-btrfs@vger.kernel.org>
To: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6e246ee64cdb6decfd7153436888efcb@smtp.arbitraryconstant.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-02-25 at 13:04 -0700, Anthony Roberts wrote:
> Hi Chris,
> 
> Cheers for the informative response. :)
> 
> > In the ideal implementation, the grub.conf has a list of devices it is
> > allowed to scan, and we put the FS uuid directly in there, let grub scan
> > them and we'll be able to boot off multiple volumes in that way.
> 
> Hm... perhaps it doesn't even need that much. It we're specifying devices,
> might it simply pull the UUID out of the initial device it's given, kinda
> like how the current mounting process works? Enumeration of the drives
> changes as they come and go, but it doesn't really matter what "hd0" is
> today as long as it's a member device.

The problem is that grub would need some way of knowing which devices to
scan.  I'd hate to see it off running through everything in a san.

> 
> This suggests another question for me... right now you can specify a root=
> command line to the kernel, though there's other stuff like nfsroot= where
> more parameters are needed. Is it possible to add a btrfsroot= option with
> a UUID+subvolume?

I'm not a huge fan of initrds, but the distro initrd scripts already
have this kind of goodness hooked in.  I think that's the best place for
it.

-chris


