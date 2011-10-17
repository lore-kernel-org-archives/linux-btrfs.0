From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: read error: how to fix?
Date: 17 Oct 2011 05:35:00 +0200
Message-ID: <Bw0YSZ7T1uB@helmut.hullen.de>
References: <1318793530.2588.28.camel@nayuki.kepstin.ca>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1318793530.2588.28.camel@nayuki.kepstin.ca>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Calvin,

Du meintest am 16.10.11:

>> I don't like to throw away a disk if it has (perhaps) repairable
>> read errors. I'd like to use a tool like "badblocks".

> Well, lets take a look at the state of your drive. Install
> smartmontools, and run 'smartctl -A /dev/sdX'. One a properly
> operational drive, you'll see these:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
> 5 Reallocated_Sector_Ct     0x0033   200   200   140    Pre-fail
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always      -       0

Here (WDC WD20EARS):

  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
  Always       -       0

197 Current_Pending_Sector  0x0032   200   200   000    Old_age
  Always       -       26
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
  Offline      -       25

-------------------

> First things first. If the VALUE of Reallocated_Sector_Ct is less
> than or equal to THRES, then your drive is garbage; all of the
> reallocation space has been used. This means many errors have
> occured, and more will keep happening. Get it replaced ASAP.

There may be hope ...

> The Current_Pending_Sector value is interesting. It counts the number
> of sectors which have had read errors, but have not been remapped
> internally in the drive, because it couldn't recover the data using
> error correction. These result in Read errors in the OS - this is
> probably what you are seeing.

> If you have pending sectors, causing the drive to reallocate them is
> very simple. Write data (any data) over the sector in question - the
> drive will then remap it onto the spare area to do the write. (The
> easiest way is to do something like dd if=/dev/zero of=/dev/sdX; but
> if you know the exact sector number, "hdparm --write-sector" can
> remap it quickly.)

Ok - I'll take a try.

> Keep in mind, though - if you have a single reallocated sector on a
> drive, it means that the drive medium is deteriorating. It's very
> likely that you will have additional failures in the future,
> resulting in more IO errors and lost data. For your sanity, I
> recommend replacing a drive as soon as you see any one error on it.

In the past most (nearly all) such problems came from a bad power supply  
and/or bad cables, "dd if=/dev/zero" or "badblocks" fixed them ...

Viele Gruesse!
Helmut
