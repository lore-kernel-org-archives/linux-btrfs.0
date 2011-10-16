From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: read error: how to fix?
Date: Sun, 16 Oct 2011 15:32:10 -0400
Message-ID: <1318793530.2588.28.camel@nayuki.kepstin.ca>
References: <BvtUmccD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BvtUmccD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2011-10-15 at 21:59 +0200, Helmut Hullen wrote:
> Hallo, Martin,
> 
> Du meintest am 15.10.11:
> 
> > RAID-0 and valuable (?) data does not match together.
> 
> I know. The data isn't valuable. It's *.mpeg2 from DVB-T, repeated at  
> least every two years. It's a kind of old LP or old VHS cassette.
> 
> But that doesn't solve the problem with errors on one of the disks. I  
> don't like to throw away a disk if it has (perhaps) repairable read  
> errors. I'd like to use a tool like "badblocks".

Well, lets take a look at the state of your drive. Install
smartmontools, and run 'smartctl -A /dev/sdX'. One a properly
operational drive, you'll see these:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       0

First things first. If the VALUE of Reallocated_Sector_Ct is less than
or equal to THRES, then your drive is garbage; all of the reallocation
space has been used. This means many errors have occured, and more will
keep happening. Get it replaced ASAP.

If the RAW_VALUE of Reallocated_Sector_Ct is above 0, then the drive has
in the past dynamically reallocated some sectors - i.e. it has had
errors, but they have been repaired.

The Current_Pending_Sector value is interesting. It counts the number of
sectors which have had read errors, but have not been remapped
internally in the drive, because it couldn't recover the data using
error correction. These result in Read errors in the OS - this is
probably what you are seeing.

If you have pending sectors, causing the drive to reallocate them is
very simple. Write data (any data) over the sector in question - the
drive will then remap it onto the spare area to do the write. (The
easiest way is to do something like dd if=/dev/zero of=/dev/sdX; but if
you know the exact sector number, "hdparm --write-sector" can remap it
quickly.)

Keep in mind, though - if you have a single reallocated sector on a
drive, it means that the drive medium is deteriorating. It's very likely
that you will have additional failures in the future, resulting in more
IO errors and lost data. For your sanity, I recommend replacing a drive
as soon as you see any one error on it.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

