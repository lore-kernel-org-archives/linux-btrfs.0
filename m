Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31200 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3FCC6f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Jun 2013 22:58:35 -0400
Date: Mon, 3 Jun 2013 10:58:51 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: George Mitchell <george@chinilu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is there a way to flag specific directories "nodatacow"?
Message-ID: <20130603025850.GB26405@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <51AB5974.3080803@chinilu.com>
 <20130603012848.GA26016@liubo.jp.oracle.com>
 <51ABFB3E.6050408@chinilu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <51ABFB3E.6050408@chinilu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 02, 2013 at 07:11:10PM -0700, George Mitchell wrote:
> On 06/02/2013 06:28 PM, Liu Bo wrote:
> >On Sun, Jun 02, 2013 at 07:40:52AM -0700, George Mitchell wrote:
> >>I am seeing massive journal corruptions that seem to be unique to
> >>btrfs and I am suspecting that cow might be causing them.  My
> >>bandaid fix for this will be to mark the /var filesystem "nodatacow"
> >>at boot.  But I am wondering if their is any way to flag a
> >>particular directory as "nodatacow" outside of the mount process.  I
> >>would like to be able to mark /var/log/journal as "nodatacow" for
> >>example, without having to declare it a subvolume and mount it
> >>separately.
> >Hi George,
> >
> >We actually have per-file/directory nodatacow :)
> >
> >But please note if you set nodatacow on the particular directory, only
> >new-created or zero-size files in the directory can follow the nocow rule.
> >
> >'chattr' in the latest e2fsprogs can fit your requirements,
> ># chattr +C /var/log/journal
> >
> >Also, what kind of massive journal corruptions?  Does it look like a
> >btrfs specific bug?
> >
> >thanks,
> >liubo
> >
> >
> Thanks Liu,
> 
> That helps a lot! I am very familiar with chattr/lsattr from my ext3
> days, but didn't know where to look for btrfs options. From what you
> are telling me the nodatacow option is identical to nodatacow option
> for ext3. Do the other ext3 options work for btrfs also?

Besides nodatacow, compression is also supported as per file/directory
basis.

> 
> As for as the corruption issue, I actually don't know whether the
> corruptions are real or whether they are being caused by the way the
> `journalctl --verify` command is interfacing with the filesystem. My
> suspicion is that metadata fragmentation *might* be somehow messing
> with the `journalctl --verify` since I can use simply `journalctl`
> and all the data flows out without error. I just cleaned out the
> /var/log/journal directory and started fresh and in no time I am
> seeing corruptions according to `journalctl --verify`. Here is what
> the output looks like:

That's weird, AFAIK it shouldn't be.

Does 'dmesg' also complain when these corruptions from 'journalctl --verify'
occurs?  (well, I'm expecting some csum errors, maybe...)

> 
> ==============================================================================
> 
> [root@localhost aide]# journalctl --verify
> Invalid object contents at 130624░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
> 0%
> File corruption detected at /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-0000000000000628-0004de2c1807989c.journal:130624
> (of 131072, 99%).
> FAIL: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-0000000000000628-0004de2c1807989c.journal
> (Bad message)
> PASS: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/user-501@e1447322cf904d028439c2d3f17d032e-000000000000065a-0004de2c18d6d96d.journal
> Invalid object contents at 125264░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
> 0%
> File corruption detected at /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-000000000000069a-0004de2c5e323847.journal:125264
> (of 131072, 95%).
> FAIL: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-000000000000069a-0004de2c5e323847.journal
> (Bad message)
> PASS: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/user-501@e1447322cf904d028439c2d3f17d032e-00000000000006a8-0004de2c73b5f19d.journal
> Invalid object contents at 128408░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
> 0%
> File corruption detected at /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-0000000000000709-0004de2cedab583c.journal:128408
> (of 131072, 97%).
> FAIL: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-0000000000000709-0004de2cedab583c.journal
> (Bad message)
> Invalid object contents at 126736░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
> 0%
> File corruption detected at /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-000000000000077f-0004de2d20abe261.journal:126736
> (of 131072, 96%).
> FAIL: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-000000000000077f-0004de2d20abe261.journal
> (Bad message)
> Invalid object contents at 129600░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
> 0%
> File corruption detected at /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-00000000000007ec-0004de2d7c50c186.journal:129600
> (of 131072, 98%).
> FAIL: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-00000000000007ec-0004de2d7c50c186.journal
> (Bad message)
> PASS: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/user-501@e1447322cf904d028439c2d3f17d032e-00000000000007f1-0004de2d87392b08.journal
> Invalid object contents at 129256░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
> 0%
> File corruption detected at /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-0000000000000862-0004de2e9a6decf4.journal:129256
> (of 131072, 98%).
> FAIL: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-0000000000000862-0004de2e9a6decf4.journal
> (Bad message)
> PASS: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/user-501@e1447322cf904d028439c2d3f17d032e-000000000000087d-0004de2eaee97998.journal
> Invalid object contents at 126032░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
> 0%
> File corruption detected at /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-00000000000008de-0004de2fb88c29cb.journal:126032
> (of 131072, 96%).
> FAIL: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-00000000000008de-0004de2fb88c29cb.journal
> (Bad message)
> PASS: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/user-501@e1447322cf904d028439c2d3f17d032e-0000000000000947-0004de30cc6f8833.journal
> Invalid object contents at 130952░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
> 0%
> File corruption detected at /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-0000000000000957-0004de30d6aad93f.journal:130952
> (of 131072, 99%).
> FAIL: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-0000000000000957-0004de30d6aad93f.journal
> (Bad message)
> PASS: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/user-501@e1447322cf904d028439c2d3f17d032e-000000000000098b-0004de31213bbbae.journal
> Invalid object contents at 124168░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
> 0%
> File corruption detected at /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-00000000000009d1-0004de31f4c7533d.journal:124168
> (of 131072, 94%).
> FAIL: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-00000000000009d1-0004de31f4c7533d.journal
> (Bad message)
> Invalid object contents at 130784░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
> 0%
> File corruption detected at /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-0000000000000a47-0004de3312e5e75d.journal:130784
> (of 131072, 99%).
> FAIL: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-0000000000000a47-0004de3312e5e75d.journal
> (Bad message)
> PASS: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/user-501@e1447322cf904d028439c2d3f17d032e-0000000000000a8d-0004de33b65f55f2.journal
> Invalid object contents at 129744░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
> 0%
> File corruption detected at /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-0000000000000abb-0004de33e97b96d8.journal:129744
> (of 131072, 98%).
> FAIL: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-0000000000000abb-0004de33e97b96d8.journal
> (Bad message)
> PASS: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/user-501@e1447322cf904d028439c2d3f17d032e-0000000000000ad1-0004de341fd95f50.journal
> Invalid object contents at 129864░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
> 0%
> File corruption detected at /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-0000000000000b37-0004de34e40af053.journal:129864
> (of 131072, 99%).
> FAIL: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system@e1447322cf904d028439c2d3f17d032e-0000000000000b37-0004de34e40af053.journal
> (Bad message)
> PASS: /var/log/journal/8846d97f611b49aa9f3d48eeac6a81f2/system.journal
> 
> ==============================================================================
> 
> So I want to try forcing "nodatacow" on this directory and see what
> happens. If that doesn't work, I suppose the next step will be to
> place this one directory on an ext4 filesystem and mount it
> externally to the btrfs /var/log. What I do know is that I have a
> parallel maintenance system on the same hardware using ext4 and it
> has never had a problem like this. I have also had a boot problem
> from the beginning and that seems like it got fixed by doing
> rigorous defragmentation on the btrfs root filesystem. So I really
> don't know at this point what is causing this problem, but I am
> determined to do my best to find out. The system I am having the
> problem with has been running Mageia 3 100% on btrfs RAID 1 migrated
> from Mageia 2 100% on 3ware hardware RAID 1. Making this transition
> has been a quite an experience, but the system is up and running
> fine. This is my day to day production system and since btrfs is
> where it is right now, this system is rigorously backed up every
> three hours to a JFS formatted drive and daily to a 4TB btrfs
> formatted drive. The system is also on UPS, but has actually hard
> crashed multiple times early on without any resulting data
> corruption. But only by using btrfs on a production system can I
> shag out all of these peripheral issues. So thanks so much for the
> tip, it will get me one step further along in sorting this out.

Thanks for trying that.

thanks,
liubo
