Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:52286 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966709AbeF1OgW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 10:36:22 -0400
Date: Thu, 28 Jun 2018 16:36:18 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: Do extra device generation check at mount time
Message-ID: <20180628143618.dcwakob5jw2ccx4y@angband.pl>
References: <20180628070443.23421-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180628070443.23421-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 28, 2018 at 03:04:43PM +0800, Qu Wenruo wrote:
> There is a reporter considering btrfs raid1 has a major design flaw
> which can't handle nodatasum files.
> 
> Despite his incorrect expectation, btrfs indeed doesn't handle device
> generation mismatch well.
> 
> This means if one devices missed and re-appeared, even its generation
> no longer matches with the rest device pool, btrfs does nothing to it,
> but treat it as normal good device.
> 
> At least let's detect such generation mismatch and avoid mounting the
> fs.

Uhm, that'd be a nasty regression for the regular (no-nodatacow) case. 
The vast majority of data is fine, and extents that have been written to
while a device is missing will be either placed elsewhere (if the filesystem
knew it was degraded) or read one of the copies to notice a wrong checksum
and automatically recover (if the device was still falsely believed to be
good at write time).

We currently don't have selective scrub yet so resyncing such single-copy
extents is costly, but 1. all will be fine if the data is read, 2. it's
possible to add such a smart resync in the future, far better than a
write-intent bitmap can do.

To do the latter, we can note the last generation the filesystem was known
to be fully coherent (ie, all devices were successfully flushed with no
mysterious write failures), then run selective scrub (perhaps even
automatically) when the filesystem is no longer degraded.  There's some
extra complexity with 3- or 4-way RAID (multiple levels of degradation) but
a single number would help even there.

But even currently, without the above not-yet-written recovery, it's
reasonably safe to continue without scrub -- it's a case of running
partially degraded when the bad copy is already known to be suspicious.

For no-nodatacow data and metadata, that is.

> Currently there is no automatic rebuild yet, which means if users find
> device generation mismatch error message, they can only mount the fs
> using "device" and "degraded" mount option (if possible), then replace
> the offending device to manually "rebuild" the fs.

As nodatacow already means "I don't care about this data, or have another
way of recovering it", I don't quite get why we would drop existing
auto-recovery for a common transient failure case.

If you're paranoid, perhaps some bit "this filesystem has some nodatacow
data on it" could warrant such a block, but it would still need to be
overridable _without_ a need for replace.  There's also the problem that
systemd marks its journal nodatacow (despite it having infamously bad
handling of failures!), and too many distributions infect their default
installs with systemd, meaning such a bit would be on in most cases.

But why would I put all my other data at risk, just because there's a
nodatacow file?  There's a big difference between scrubbing when only a few
transactions worth of data is suspicious and completely throwing away a
mostly-good replica to replace it from the now fully degraded copy.

> I totally understand that, generation based solution can't handle
> split-brain case (where 2 RAID1 devices get mounted degraded separately)
> at all, but at least let's handle what we can do.

Generation can do well at least unless both devices were mounted elsewhere
and got the exact same number of transactions, the problem is that nodatacow
doesn't bump generation number.

> The best way to solve the problem is to make btrfs treat such lower gen
> devices as some kind of missing device, and queue an automatic scrub for
> that device.
> But that's a lot of extra work, at least let's start from detecting such
> problem first.

I wonder if there's some way to treat problematic nodatacow files as
degraded only?

Nodatacow misses most of btrfs mechanisms, thus to get it done right you'd
need to pretty much copy all of md's logic, with a write-intent bitmap or an
equivalent.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ There's an easy way to tell toy operating systems from real ones.
⣾⠁⢰⠒⠀⣿⡁ Just look at how their shipped fonts display U+1F52B, this makes
⢿⡄⠘⠷⠚⠋⠀ the intended audience obvious.  It's also interesting to see OSes
⠈⠳⣄⠀⠀⠀⠀ go back and forth wrt their intended target.
