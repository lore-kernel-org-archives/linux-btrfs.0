From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Mysteriously changing RAID levels
Date: Thu, 17 Jun 2010 05:53:26 -0400
Message-ID: <20100617095326.GL27466@think>
References: <AANLkTinwCgndAxTGOAnzybhpAXG8DnemHj25WFR4489N@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinwCgndAxTGOAnzybhpAXG8DnemHj25WFR4489N@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 16, 2010 at 08:12:03AM -0600, cwillu wrote:
> I just noticed today that "btrfs fi df /" no longer reports any raid
> level on Metadata or Data.  I know as of Jun 4 that Data was RAID1 and
> Metadata was DUP (I had posted my df output to irc).  I've already
> checked that I didn't revert to an old version of btrfs-progs, and am
> at a bit of a loss to explain it.
> 
> I'm currently running 2.6.35rc1.
> 
> Any ideas what could have caused this?

Thanks for pointing this out, the ioctl needs to be updated.  I'll get
it fixed up.

-chris
