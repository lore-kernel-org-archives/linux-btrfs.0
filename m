Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:44010 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2E2IPD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 04:15:03 -0400
Message-ID: <4FC48570.404@panasas.com>
Date: Tue, 29 May 2012 11:14:40 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: atime and filesystems with snapshots (especially Btrfs)
References: <CAB9VWqAUkHH2xBXZ+edTSCffiLtEXamfugKrPZ6T0Py92kyZdA@mail.gmail.com>
In-Reply-To: <CAB9VWqAUkHH2xBXZ+edTSCffiLtEXamfugKrPZ6T0Py92kyZdA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/25/2012 06:35 PM, Alexander Block wrote:

> Hello,
> 
> (this is a resend with proper CC for linux-fsdevel and linux-kernel)
> 
> I would like to start a discussion on atime in Btrfs (and other
> filesystems with snapshot support).
> 
> As atime is updated on every access of a file or directory, we get
> many changes to the trees in btrfs that as always trigger cow
> operations. This is no problem as long as the changed tree blocks are
> not shared by other subvolumes. Performance is also not a problem, no
> matter if shared or not (thanks to relatime which is the default).
> The problems start when someone starts to use snapshots. If you for
> example snapshot your root and continue working on your root, after
> some time big parts of the tree will be cowed and unshared. In the
> worst case, the whole tree gets unshared and thus takes up the double
> space. Normally, a user would expect to only use extra space for a
> tree if he changes something.
> A worst case scenario would be if someone took regular snapshots for
> backup purposes and later greps the contents of all snapshots to find
> a specific file. This would touch all inodes in all trees and thus
> make big parts of the trees unshared.
> 
> relatime (which is the default) reduces this problem a little bit, as
> it by default only updates atime once a day. This means, if anyone
> wants to test this problem, mount with relatime disabled or change the
> system date before you try to update atime (that's the way i tested
> it).
> 
> As a solution, I would suggest to make noatime the default for btrfs.
> I'm however not sure if it is allowed in linux to have different
> default mount options for different filesystem types. I know this
> discussion pops up every few years (last time it resulted in making
> relatime the default). But this is a special case for btrfs. atime is
> already bad on other filesystems, but it's much much worse in btrfs.
> 


Sounds like a real problem. I would suggest a few remedies.
1. Make a filesystem persistent parameter that says noatime/relatime/atime
   So the default if not specified on mount is taken as a property of
   the FS (mkfs can set it)
2. The snapshot program should check and complain if it is on, and recommend
   an off. Since the problem only starts with a snapshot.
3. If space availability drops under some threshold, disable atime. As you said
   this is catastrophic in this case. So user can always search and delete files.
   In fact if the IO was only because of atime, it should be a soft error, warned,
   and ignored.

But perhaps the true solution is to put atime on a side table, so only the atime
info gets COW and not the all MetaData

Just my $0.017
Boaz

> Alex.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


