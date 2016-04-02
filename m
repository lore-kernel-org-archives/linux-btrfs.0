Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58144 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbcDBUQq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Apr 2016 16:16:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1amRyM-0001rR-1D
	for linux-btrfs@vger.kernel.org; Sat, 02 Apr 2016 22:16:42 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 22:16:42 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 22:16:42 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
Date: Sat, 2 Apr 2016 22:16:34 +0200
Message-ID: <20160402221634.2e3dc71c@jupiter.sol.kaishome.de>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<20160402110001.0ec354b5@jupiter.sol.kaishome.de>
	<CAPmG0jaJdS26ABbC3Rz_D_FDfCKq8mYMHhmFwqhWYpDRdyFQhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sat, 2 Apr 2016 19:17:55 +0200
schrieb Henk Slager <eye1tm@gmail.com>:

> On Sat, Apr 2, 2016 at 11:00 AM, Kai Krakow <hurikhan77@gmail.com>
> wrote:
> > Am Fri, 1 Apr 2016 01:27:21 +0200
> > schrieb Henk Slager <eye1tm@gmail.com>:
> >  
> >> It is not clear to me what 'Gentoo patch-set r1' is and does. So
> >> just boot a vanilla v4.5 kernel from kernel.org and see if you get
> >> csum errors in dmesg.  
> >
> > It is the gentoo patchset, I don't think anything there relates to
> > btrfs:
> > https://dev.gentoo.org/~mpagano/genpatches/trunk/4.5/
> >  
> >> Also, where does 'duplicate object' come from? dmesg ? then please
> >> post its surroundings, straight from dmesg.  
> >
> > It was in dmesg. I already posted it in the other thread and Qu took
> > note of it. Apparently, I didn't manage to capture anything else
> > than:
> >
> > btrfs_run_delayed_refs:2927: errno=-17 Object already exists
> >
> > It hit me unexpected. This was the first time btrfs went RO for me.
> > It was with kernel 4.4.5 I think.
> >
> > I suspect this is the outcome of unnoticed corruptions that sneaked
> > in earlier over some period of time. The system had no problems
> > until this incident, and only then I discovered the huge pile of
> > corruptions when I ran btrfsck.
> >
> > I'm also pretty convinced now that VirtualBox itself is not the
> > problem but only victim of these corruptions, that's why it
> > primarily shows up in the VDI file.
> >
> > However, I now found csum errors in unrelated files (see other post
> > in this thread), even for files not touched in a long time.  
> 
> Ok, this is some good further status and background. That there are
> more csum errors elsewhere is quite worrying I would say. You said HW
> is tested, are you sure there no rare undetected failures, like due to
> overclocking or just aging or whatever. It might just be that spurious
> HW errors just now start to happen and are unrelated to kernel upgrade
> from 4.4.x to 4.5.
> I had once a RAM module going bad; Windows7 ran fine (at least no
> crashes), but when I booted with Linux/btrfs, all kinds of strange
> btrfs errors started to appear including csum errors.

I'll go checking the RAM for problems - tho that would be the first
time in twenty years that a RAM module hadn't errors from the
beginning. Well, you'll never know. But I expect no error since usually
this would mean all sorts of different and random problems which I
don't have. Problems are very specific, which is atypical for RAM
errors.

The hardware is not overclocked, every part was tested when installed.

> The other thing you could think about is the SSD cache partition. I
> don't remember if blocks from RAM to SSD get an extra CRC attached
> (independent of BTRFS). But if data gets corrupted while in the SSD,
> you could get very nasty errors, how nasty depends a bit on the
> various bcache settings. It is not unthinkable that dirty changed data
> gets written to the harddisks. But at least btrfs (scub) can detect
> that (the situation you are in now).

Well, the SSD could in fact soon become a problem. It's at 97% of its
lifetime according to SMART. I'm probably somewhere near 85TB (that's
the lifetime spec of the SSD) of written data within one year thanks to
some unfortunate disk replacement (btrfs replace) action with btrfs
through bcache, and weekly scrubs (which does not just read, but
writes).

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE 1 Raw_Read_Error_Rate     0x002f   100
100   000    Pre-fail  Always       -       1 5 Reallocate_NAND_Blk_Cnt
0x0033   100   100   000    Pre-fail  Always       -       0 9
Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       8705 12 Power_Cycle_Count       0x0032   100
100   000    Old_age   Always       -       286 171
Program_Fail_Count      0x0032   100   100   000    Old_age
Always       -       0 172 Erase_Fail_Count        0x0032   100   100
000    Old_age   Always       -       0 173 Ave_Block-Erase_Count
0x0032   003   003   000    Old_age   Always       -       2913 174
Unexpect_Power_Loss_Ct  0x0032   100   100   000    Old_age
Always       -       112 180 Unused_Reserve_NAND_Blk 0x0033   000
000   000    Pre-fail  Always       -       1036 183
SATA_Interfac_Downshift 0x0032   100   100   000    Old_age
Always       -       0 184 Error_Correction_Count  0x0032   100   100
000    Old_age   Always       -       0 187 Reported_Uncorrect
0x0032   100   100   000    Old_age   Always       -       0 194
Temperature_Celsius     0x0022   067   057   000    Old_age
Always       -       33 (Min/Max 20/43) 196 Reallocated_Event_Count
0x0032   100   100   000    Old_age   Always       -       0 197
Current_Pending_Sector  0x0032   100   100   000    Old_age
Always       -       0 198 Offline_Uncorrectable   0x0030   100   100
000    Old_age   Offline      -       0 199 UDMA_CRC_Error_Count
0x0032   100   100   000    Old_age   Always       -       0 202
Percent_Lifetime_Used   0x0031   003   003   000    Pre-fail
Offline      -       97 206 Write_Error_Rate        0x000e   100
100   000    Old_age   Always       -       0 210
Success_RAIN_Recov_Cnt  0x0032   100   100   000    Old_age
Always       -       0 246 Total_Host_Sector_Write 0x0032   100   100
000    Old_age   Always       -       42879382296 247
Host_Program_Page_Count 0x0032   100   100   000    Old_age
Always       -       1495038460 248 Bckgnd_Program_Page_Cnt 0x0032
100   100   000    Old_age   Always       -       42326578695


> Maybe to further isolate just btrfs, you could temporary rule out
> bcache by making sure the cache is clean and then increase the
> startsectors of second partitions on the harddisks by 16 (8KiB) and
> then reboot. Of course after any write to the partitions, you'll have
> to recreate all bcache.

Bcache had some patches lately for problems I never experienced. At
this point, I'd also not rule out bcache as the fault. Tho, bcache
itself had no problems (I have one other system where bcache broke down
after those patches were applied, resulting in a broken bcache b-tree).

> But maybe it is just due to bugs in older kernels that the fs has been
> silently corrupted and now kernel 4.5 cannot handle it anymore and any
> use of the fs increases corruption.

I'm pretty sure the problems sneaked in during running older kernels,
and the FS going RO was only tip of the iceberg.

My last "error free" rsync backup is from mid March. By that time, I
probably had no csum errors in files with young modification time - but
since I only in-place sync files with changed mod-time, I cannot rule
out csum errors having already been there. My script only takes
snapshots of the backup scratch area when rsync was successful, thus my
last snapshot from mid March holds valid copies of the broken files
while the scratch area has a current backup with some files broken (due
to in-place sync). [1]

According to previous inspections, that backup FS is in good shape -
the only btrfsck errors have been false alerts which have been fixed by
Qu (thanks BTW).

Interesting thing is:

As with the first file with csum errors (the VDI file), also the second
file has csum errors again when recreated. It's a game data file from
Steam. I removed it (then the FS went RO, mentioned earlier in this
thread). Now, Steam re-downloaded the file to a temp directory - so
obviously it's a completely new file (except Steam somehow magically
recovered it from somewhere else). But this new file has csum errors
again. WTH? And Steam forces the FS RO when working with this file.

So, either the SSD (thru bcache) or btrfs' compression algorithms show
bugs with very specific data patterns (since I'm using compress=lzo),
or the other corruptions make btrfs destroy those new files and it
allocates space over and over again from affected areas of the disk. I
don't know how btrfs allocation works - but that may be an explanation
(wrt the backpointer errors).

BTW: Replacement SSD already ordered. At the current rate the old
one will reach 100% lifetime in about 4-6 weeks.

[1]: As a reference or if you're curious:
https://gist.github.com/kakra/5520370

-- 
Regards,
Kai

Replies to list-only preferred.

