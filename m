From: Tobias Oetiker <tobi@oetiker.ch>
Subject: Re: Benchmarking btrfs on HW Raid ... BAD
Date: Mon, 28 Sep 2009 11:39:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0909281124410.11292@sebohet.brgvxre.pu>
References: <alpine.DEB.2.00.0909280955400.11292@sebohet.brgvxre.pu>  <82tyynxz2g.fsf@mid.bfk.de> <6278d2220909280219h5b38577eqc1bee1a26cbc93e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Florian Weimer <fweimer@bfk.de>, linux-btrfs@vger.kernel.org
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6278d2220909280219h5b38577eqc1bee1a26cbc93e1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Daniel,

Today Daniel J Blueman wrote:

> On Mon, Sep 28, 2009 at 9:17 AM, Florian Weimer <fweimer@bfk.de> wrote:
> > * Tobias Oetiker:
> >
> >> Running this on a single disk, I get the quite acceptable results.
> >> When running on-top of a Areca HW Raid6 (lvm partitioned)
> >> then both read and write performance go down by at least 2
> >> magnitudes.
> >
> > Does the HW RAID use write caching (preferably battery-backed)?
>
> I believe Areca controllers have an option for writeback or
> writethrough caching, so it's worth checking this and that you're
> running the current firmware, in case of errata. Ironically, disabling
> writeback will give the OS tighter control of request latency, but
> throughput may drop a lot. I still can't help thinking that this is
> down to the behaviour of the controller, due to the 1-disk case
> working well.

it certainly is down to  a behaviour of the controller, or the
results would be the same as with a single sata disk :-) It would
be interesting to see what results others get on HW Raid
Controllers ...

> One way would be to configure the array as 6 or 7 devices, and allow
> BTRFS/DM to mange the array, then see if performance under write load
> is better, and with or without writeback caching...

I can imagine that this would help, but since btrfs aims to be
multipurpose, this does not realy help all that much since this
fundamentally alters the 'conditions' at the moment the RAID
contains different filesystem and is partitioned using lvm ...

cheers
tobi

the results for ext3 fs look like this ...



-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
