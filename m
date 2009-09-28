From: Tobias Oetiker <tobi@oetiker.ch>
Subject: Re: Benchmarking btrfs on HW Raid ... BAD
Date: Mon, 28 Sep 2009 11:19:22 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0909281118180.11292@sebohet.brgvxre.pu>
References: <alpine.DEB.2.00.0909280955400.11292@sebohet.brgvxre.pu> <82tyynxz2g.fsf@mid.bfk.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Florian Weimer <fweimer@bfk.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <82tyynxz2g.fsf@mid.bfk.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Florian,

Today Florian Weimer wrote:

> * Tobias Oetiker:
>
> > Running this on a single disk, I get the quite acceptable results.
> > When running on-top of a Areca HW Raid6 (lvm partitioned)
> > then both read and write performance go down by at least 2
> > magnitudes.
>
> Does the HW RAID use write caching (preferably battery-backed)?

yes it does ...  is there some magic switch to be set for btrfs to
act accordingly ?

cheers
tobi
>
>

-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
