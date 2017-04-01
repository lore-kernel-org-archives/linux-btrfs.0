Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37873 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750842AbdDAIZO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Apr 2017 04:25:14 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cuELK-0004Uv-GV
        for linux-btrfs@vger.kernel.org; Sat, 01 Apr 2017 10:25:06 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: backing up a file server with many subvolumes
Date: Sat, 1 Apr 2017 10:24:31 +0200
Message-ID: <20170401102431.5c6b5643@jupiter.sol.kaishome.de>
References: <58D72EC4.9020101@gmail.com>
        <59dccd7e-6cb6-ea66-3150-0ce85472e73a@rqc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 27 Mar 2017 08:57:17 +0300
schrieb Marat Khalili <mkh@rqc.ru>:

> Just some consideration, since I've faced similar but no exactly same 
> problem: use rsync, but create snapshots on target machine. Blind
> rsync will destroy deduplication of your snapshots and take huge
> amount of storage, so it's not a solution. But you can rsync --inline
> your snapshots in chronological order to some folder and re-take
> snapshots of that folder, thus recreating your snapshots structure on
> target. Obviously, it can/should be automated.

I think it's --inplace and --no-whole-file...

Apparently, rsync cannot detect moved files which was a big deal for me
regarding deduplication, so I found another solution which is even
faster. See my other reply.

> On 26/03/17 06:00, J. Hart wrote:
> > I have a Btrfs filesystem on a backup server.  This filesystem has
> > a directory to hold backups for filesystems from remote machines.
> > In this directory is a subdirectory for each machine.  Under each
> > machine subdirectory is one directory for each filesystem
> > (ex /boot, /home, etc) on that machine.  In each filesystem
> > subdirectory are incremental snapshot subvolumes for that
> > filesystem.  The scheme is something like this:
> >
> > <top>/backup/<machine>/<filesystem>/<many snapshot subvolumes>
> >
> > I'd like to try to back up (duplicate) the file server filesystem 
> > containing these snapshot subvolumes for each remote machine.  The 
> > problem is that I don't think I can use send/receive to do this. 
> > "Btrfs send" requires "read-only" snapshots, and snapshots are not 
> > recursive as yet.  I think there are too many subvolumes which
> > change too often to make doing this without recursion practical.
> >
> > Any thoughts would be most appreciated.
> >
> > J. Hart
> >
> > -- 
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



-- 
Regards,
Kai

Replies to list-only preferred.

