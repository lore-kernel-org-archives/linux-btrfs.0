From: Kaspar Schleiser <kaspar@schleiser.de>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Wed, 09 May 2012 16:46:42 +0200
Message-ID: <4FAA8352.4020304@schleiser.de>
References: <20120508200228.GM8938@carfax.org.uk> <C8TGo1T9CXB@helmut.hullen.de> <20120509025646.2894f7ea@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120509025646.2894f7ea@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 05/08/2012 10:56 PM, Roman Mamedov wrote:
> Regarding btrfs, AFAIK even "btrfs -d single" suggested above works not "per
> file", but per allocation extent, so in case of one disk failure you will lose
> random *parts* (extents) of random files, which in effect could mean no file
> in your whole file system will remain undamaged.
Maybe we should evaluate the possiblility of such a "one file gets on 
one disk" feature.

Helmut Hullen has the use case: Many disks, totally non-critical but 
nice-to-have data. If one disk dies, some *files* should lost, not some 
*random parts of all files*.

This could be accomplished by some userspace-tool that moves stuff 
around, combined with "file pinning"-support, that lets the user make 
sure a specific file is on a specific disk.

Cheers
Kaspar



