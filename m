From: Fabian Zeindl <fabian.zeindl@gmail.com>
Subject: Re: Why does Btrfs allow raid1 with mismatched drives? Also: How to look behind the curtain
Date: Thu, 5 Jan 2012 10:53:28 +0100
Message-ID: <DFD486DD-C324-43EE-82BC-87DDCF432DB6@gmail.com>
References: <4D48BA4B-AB66-46A2-8E79-050B798C9A3E@gmail.com> <20120105094444.GF27122@carfax.org.uk>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120105094444.GF27122@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, January 5, 2012 at 10:44 , Hugo Mills wrote:
> You should probably read the mis-named "Sysadmin's Guide" 
> on the wiki[1], which explains what btrfs actually does with its
> replication.
> 
> You should also probably read the FAQ entries on free space[2],
> since using plain "df" for btrfs is usually misleading.

I read both, but it doesn't answer my question on how btrfs behaves when it can't actually do a raid1, because there's not enough data on an "other" disk for a chunk-copy.

> You could run a scrub, which will verify all of the data mirrors on
> the volume, and fix anything that's not redundant.

Will this command fail then for example?

fabian