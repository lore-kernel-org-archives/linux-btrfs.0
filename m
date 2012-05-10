From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Thu, 10 May 2012 12:40:49 +0200
Message-ID: <201205101240.49200.Martin@lichtvoll.de>
References: <20120508200228.GM8938@carfax.org.uk> <20120509025646.2894f7ea@natsu> <4FAA8352.4020304@schleiser.de> (sfid-20120509_173342_317782_AFED1728)
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Kaspar Schleiser <kaspar@schleiser.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FAA8352.4020304@schleiser.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 9. Mai 2012 schrieb Kaspar Schleiser:
> Hi,
> 
> On 05/08/2012 10:56 PM, Roman Mamedov wrote:
> > Regarding btrfs, AFAIK even "btrfs -d single" suggested above works
> > not "per file", but per allocation extent, so in case of one disk
> > failure you will lose random *parts* (extents) of random files,
> > which in effect could mean no file in your whole file system will
> > remain undamaged.
> 
> Maybe we should evaluate the possiblility of such a "one file gets on
> one disk" feature.
> 
> Helmut Hullen has the use case: Many disks, totally non-critical but
> nice-to-have data. If one disk dies, some *files* should lost, not some
> *random parts of all files*.
> 
> This could be accomplished by some userspace-tool that moves stuff
> around, combined with "file pinning"-support, that lets the user make
> sure a specific file is on a specific disk.

Yeah, basically I think thats the whole point Helmut is trying to make.

I am not sure whether that should be in userspace. It could be just an 
allocation mode like "raid0" or "single". Such as "single" as in one file 
is really on one disk and thats it.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
