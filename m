From: David Sterba <dave@jikos.cz>
Subject: Re: checkums when converting from ext[234] to Btrfs
Date: Thu, 5 Jan 2012 16:45:41 +0100
Message-ID: <20120105154541.GN7322@twin.jikos.cz>
References: <1325157169.28566.21.camel@lupus> <1325686931.2127.112.camel@lupus>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: pubny <pubny@xs4all.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325686931.2127.112.camel@lupus>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 04, 2012 at 03:22:11PM +0100, pubny wrote:
> Could someone help me with a clarification whether the btrfs-convert
> tool creates checksums on blocks of the existing ext[234] filesystem?

yes, it does checksum by default and you can switch it off with the '-d'
option.

> Any experiences how the size and the filesystem utilization (used vs.
> total diskspace) impacts the time of conversion?

I don't have numbers but it needs to go through extX metadata, read and
checksum data blocks, then write btrfs metadata. Nothing where a
significant time could be saved (except switching off the checksums).


david
