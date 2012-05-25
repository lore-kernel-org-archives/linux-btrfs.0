Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35750 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab2EYTKn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 15:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAB9VWqAUkHH2xBXZ+edTSCffiLtEXamfugKrPZ6T0Py92kyZdA@mail.gmail.com>
References: <CAB9VWqAUkHH2xBXZ+edTSCffiLtEXamfugKrPZ6T0Py92kyZdA@mail.gmail.com>
Date: Fri, 25 May 2012 21:10:43 +0200
Message-ID: <CAB9VWqAV+TohoMP0pcP6D6SEWB4o40XbHQssO1_Mbz3d_kUHaA@mail.gmail.com>
Subject: Re: atime and filesystems with snapshots (especially Btrfs)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 25, 2012 at 5:35 PM, Alexander Block
<ablock84@googlemail.com> wrote:
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
> Alex.

Just to show some numbers I made a simple test on a fresh btrfs fs. I
copied my hosts /usr (4 gig) folder to that fs and checked metadata
usage with "btrfs fi df /mnt", which was around 300m. Then I created
10 snapshots and checked metadata usage again, which didn't change
much. Then I run "grep foobar /mnt -R" to update all files atime.
After this was finished, metadata usage was 2.59 gig. So I lost 2.2
gig just because I searched for something. If someone already has
nearly no space left, he probably won't be able to move some data to
another disk, as he may get ENOSPC while copying the data.

Here is the output of the final "btrfs fi df":

# btrfs fi df /mnt
Data: total=6.01GB, used=4.19GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=3.25GB, used=2.59GB
Metadata: total=8.00MB, used=0.00

I don't know much about other filesystems that support snapshots, but
I have the feeling that most of them would have the same problem. Also
all other filesystems in combination with LVM snapshots may cause
problems (I'm not very familiar with LVM). Filesystem image formats,
like qcow, vmdk, vbox and so on may also have problems with atime.
