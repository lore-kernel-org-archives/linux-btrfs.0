Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:58322 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752513AbeBJWFu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Feb 2018 17:05:50 -0500
Date: Sat, 10 Feb 2018 23:05:49 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: "Ellis H. Wilson III" <ellisw@panasas.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-cleaner / snapshot performance analysis
Message-ID: <20180210220549.GA30438@polanet.pl>
References: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
 <96cd9e57-cde4-5bc4-0312-02b54668e59a@mendix.com>
 <76e7f364-62b9-5ef1-a8ed-f6fb9e534963@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <76e7f364-62b9-5ef1-a8ed-f6fb9e534963@panasas.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 10, 2018 at 13:29:15 -0500, Ellis H. Wilson III wrote:

>> Well, sometimes those answers help. :) "Oh, yes, I disabled qgroups, I
>> didn't even realize I had those, and now the problem is gone."
> 
> I meant less than helpful for me, since for my project I need detailed 
> and fairly accurate capacity information per sub-volume, and the 

You won't have anything close to "accurate" in btrfs - quotas don't
include space wasted by fragmentation, which happens to allocate from tens
to thousands times (sic!) more space than the files itself.
Not in some worst-case scenarios, but in real life situations...
I got 10 MB db-file which was eating 10 GB of space after a week of
regular updates - withOUT snapshotting it. All described here.

> relationship between qgroups and subvolume performance wasn't being 
> spelled out in the responses.  Please correct me if I am wrong about 
> needing qgroups enabled to see detailed capacity information 
> per-subvolume (including snapshots).

Yes, you need that. But while snapshots are in use, it's not
straighforward to interpret the values, especially in regard of
exclusive spaace (which is not a btrfs limitation, just pure logical
conclusion) - this was also described in my thread.

> course) or how many subvolumes/snapshots there are.  If I know that 
> above N snapshots per subvolume performance tanks by M%, I can apply 
> limits on the use-case in the field, but I am not aware of those kinds 
> of performance implications yet.

This doesn't work like this. It all depends on data that are subject of
snapshots, especially how they are updated. How exactly, including write
patterns.

I think you expect answers that can't be formulated - with fs architecture so
advanced as ZFS or btrfs it's behavior can't be analyzed for simple
answers like 'keep less than N snapshots'.

If you want PRACTICAL rules, there is one not known commonly: since
the btrfs limitation is that defragmentation breaks CoW links, so all
your snapshots can grow like regular copies, defrag data just
before snapshotting them.

> I noticed the problem when Thunderbird became completely unresponsive. 

Is it using some database engine for storage? Mark the files with nocow.

This is an exception of easy-answer: btrfs doesn't handle databases with
CoW. Period. Doesn't matter if snapshotted or not, ANY database files
(systemd-journal, PostgreSQL, sqlite, db) are not handled at all. They
slow down entire system to the speed of cheap SD card.

If you have btrfs on your home partition, make sure that AT LEAST all
$USER/.cache directories are chattr +C. The same applies to entire /var
partition and dozen of other various directories with user-databases
(~/.mozilla/firefox, ~/.ccache and many many more application-specific).

In fact, if you want the quotas to be accurate, you NEED to mount every
volume with possibly hostile write patterns (like /home) as nocow.


Actually, if you do not use compression and don't need checksums of data
blocks, you may want to mount all the btrfs with nocow by default.
This way the quotas would be more accurate (no fragmentation _between_
snapshots) and you'll have some decent performance with snapshots.
If that is all you care.

-- 
Tomasz Pala <gotar@pld-linux.org>
