Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbaEEQQM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 May 2014 12:16:12 -0400
Date: Mon, 5 May 2014 18:16:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Very high load when reading/writing
Message-ID: <20140505161611.GT5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53628953.8030707@friedels.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53628953.8030707@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 01, 2014 at 07:50:11PM +0200, Hendrik Friedel wrote:
> I have very high load when writing/reading from/to two of my btrfs volumes.
> One sda1, mounted as /mnt/BTRFS, the other, sdd2/sde2 (raid) as /
> sda1 is a 3TB disc, whereas the sdd2/sde2 are small SSDs of 16GB.
> 
> I wrote a small script to demonstrate it. It does:
> -echo what it will do
> -show the current load
> -dd from one volume to the other.
> -show the current load
> -sync and flush the cache
> -sleep 300s in order to get the load down again.

load average is not a good metric, it mixes IO an CPU load into one
number, would be better to measure cpu and IO loads separately.

> Here the output:
> Test from /mnt/BTRFS to /tmp
> 124,553 s, 16,8 MB/s

Is the transfer speed comparable if using a bare blockdevice instead of
a filesystem on top of that?

According to the S.M.A.R.T. stats the devices seem to be working
normally.
