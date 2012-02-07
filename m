From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Understanding Default RAID Behavior
Date: Tue, 7 Feb 2012 10:17:19 +0000 (UTC)
Message-ID: <pan.2012.02.07.10.17.18@cox.net>
References: <4F30AF89.4090402@techsym.com> <o70709-9m4.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Tue, 07 Feb 2012 08:25:10 +0100 as excerpted:

> Mario Lopez <mario.lopez@techsym.com> schrieb:
> 
>> The Wiki does not make it clear as to why adding a secondary device
>> defaults to RAID1 metadata and RAID0 data. I bought two SSDs with the
>> intention of doing a BTRFS RAID0 for my root.
>> 
>> What is the difference between forcing RAID0 on metadata and data as
>> opposed to the default behavior? Can anyone clarify that?
> 
> I think the purpose is that on meta data corruption (which can happen
> and is probably more important than file data) the file system can
> "heal" itself by replacing a corrupted meta data block with an intact
> copy. Also during scrubbing btrfs will check all those blocks and
> magically fix broken ones.

Further toward the same point, it's worth noting that btrfs' defaults are 
double-metadata even on SINGLE spindles (single data, double metadata, is 
the default).

If a block of data is corrupted, you've only lost that block, generally a 
portion of a single file.  If a block of metadata is corrupted, it can 
kill access to multiple files, and due to tail-packing, corrupt the data 
itself for many files.  Several btrfs features including double-metadata 
and data/metadata checksumming are designed to provide better than 
traditional filesystem and data integrity, and the double-metadata 
feature is a critical part of that.

But of course the fact that you (OP) are targeting raid0 in the first 
place indicates that you're not particularly concerned about data 
integrity, but instead want speed and performance.  Presumably that means 
that you either have backups of the data you'll be storing there (be they 
local or simply data that can be downloaded from elsewhere on the net 
again, if necessary), or it's not critical data that you'll be unduly 
inconvenienced if it's lost in any case.  As such, you may well wish to 
run raid0 metadata as well, strictly for the performance, since you're 
deliberately declaring the data not worth worrying about losing by 
running it raid0.

If that is indeed the case, it's worth looking at the various mount 
options, etc, as well, including the no-checksumming option, etc, thus 
further speeding things up.  Once you go single metadata, you're already 
giving up a good portion of your ability to recover from bad metadata 
checksums in any case, so you might as well avoid the overhead of 
checksumming entirely.  nocow is another potential option, tho whether it 
increases performance or decreases it will depend on your data and 
usage.  Similarly with the compression options, which will increase I/O 
bandwidth at the cost of CPU cycles, so depending on where your 
bottleneck is (it's likely a far closer call with SSDs than with spinning 
media, tho, as spinning media will benefit from compression far more due 
to their worse I/O bottleneck).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

