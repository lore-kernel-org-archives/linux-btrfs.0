From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: Integration branch updated
Date: Mon, 27 Jun 2011 15:03:30 +0200
Message-ID: <4E087FA2.8040105@gmail.com>
References: <20110626211022.GA24675@carfax.org.uk> <20110627124300.GR12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110627124300.GR12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 27.06.2011 14:43, David Sterba wrote:
> On Sun, Jun 26, 2011 at 10:10:22PM +0100, Hugo Mills wrote:
>> I've just updated the btrfs-progs integration branch I've been
>> keeping. Not a huge amount new since last time:
>>
>> Andreas Philipp (1):
>> print parent ID in btrfs subvolume list
>
> dunno if this has been mentioned already, but this change breaks
> xfstests/254 and needs a patch once merged.
Sorry, I was not aware of the problem with xfstests/254. But as far as
I see, xfstests/254 tests explicitly for subvolume/snapshot features
in btrfs and uses a specific filter to parse the output of btrfs
subvolume list. If this output changes (without introducing another
error), then "only" the test is broken.
Any suggestions on how to change the patch? Maybe adding a flag (-p ?)
to add the parent ID in the output and leave the standard output
untouched?

As mentioned in my original mail this patch is based on Hugos
integration branch integration-20110611.

Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJOCH+hAAoJEJIcBJ3+Xkgix4wQAKChVr6FITZedfI5s1/BE/gD
PRV8vjsYZQtUwNTQnUN1x+IEAgwpxmwOmBcQdOZ69zrxJlaozbu3fEn+EtDDdmBl
UcKRyCAEG2CP7lxGi6cerCq7e1m9EIw2wAd5ImnJZcUKUEOu/8oIeB2PPC1Z6J1s
edzgXzndk01LoxTBn6CiCX3CfMsWhr1h8RrVolWz0sEXUe8tw4cZT88Pd2IHSK1i
wvI3rXDAV7dTna4B9HOD9Uw1SqUfnIPOyGLs8JSguT8cJ74Z9bOP46gS4QX+yfDA
oPOj9LYBT4CyU06I/nYeL0BJkQPPtMa9KfTqE7UAgK0whPpG+MIaKkh4XXxaqDyC
IMn/rXVOpRDhe1CBOJvyUuGhJafkEQgP4RmvxWrA5ev6bL4nzvToK3FWmgEqx3Ki
ZuXEJ+05AVTlsFI5D+LtQSTI/xVq8xkJRSNFKGDuffKcm5/iWAO7M/qG1shg10c8
8p3WHGKr+vhuxNoK6DpeYYaAQYafXo2ijlmnE/8vecAFQCtxifpkshHJLPe+hB0Q
YDG2AKBsWhxFbPSfgSQdjlFiZrGR3FqVaivYWdy4d+nHI1M6dYVFHI0WCzY4fbjS
na74iuWsZfV209HasTk9wUSebYWJPn5YhmL7wWnD9auEI0G+nz+H9XeS2sAb66gX
4VF7Aa7Xdw1/PM4u/vgw
=RrQF
-----END PGP SIGNATURE-----

