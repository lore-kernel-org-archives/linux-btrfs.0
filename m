From: Chris Mason <chris.mason@oracle.com>
Subject: Re: New data=ordered code pushed out to btrfs-unstable
Date: Mon, 28 Jul 2008 19:52:40 +0000
Message-ID: <1217274760.7572.107.camel@think.oraclecorp.com>
References: <1216398992.6932.36.camel@think.oraclecorp.com>
	 <4880F87B.7020908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4880F87B.7020908@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-07-18 at 16:09 -0400, Ric Wheeler wrote:

> Just to kick the tires, I tried the same test that I ran last week on 
> ext4. Everything was going great, I decided to kill it after 6 million 
> files or so and restart.
> 
> The unmount has taken a very, very long time - seems like we are 
> cleaning up the pending transactions at a very slow rate:

For many workloads, the long unmount time is now fixed in btrfs-unstable
as well (thanks to a cache from Yan Zheng).

For fs_mark, I created 10 million files (20k each) and was able to
unmount in 2s.

-chris



