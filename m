Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:45824 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaJMUz7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 16:55:59 -0400
Received: by mail-vc0-f170.google.com with SMTP id hy10so6483350vcb.15
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 13:55:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANg_oxytS04xrVLfWzgz7sJZBArJ-HM8nGADF+ujjRy8heYjqQ@mail.gmail.com>
References: <543450DC.90504@prnet.org>
	<1412714780.2374.0@mail.thefacebook.com>
	<543A61EE.7070200@prnet.org>
	<CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>
	<543C35C3.9070002@prnet.org>
	<CANg_oxytS04xrVLfWzgz7sJZBArJ-HM8nGADF+ujjRy8heYjqQ@mail.gmail.com>
Date: Mon, 13 Oct 2014 16:55:58 -0400
Message-ID: <CAGfcS_mtYg6OSggo+t5ksxafOn0hxhtsO86k924RA55XqxzGQQ@mail.gmail.com>
Subject: Re: btrfs random filesystem corruption in kernel 3.17
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: john terragon <jterragon@gmail.com>
Cc: David Arendt <admin@prnet.org>, Chris Mason <clm@fb.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 13, 2014 at 4:48 PM, john terragon <jterragon@gmail.com> wrote:
> I think I just found a consistent simple way to trigger the problem
> (at least on my system). And, as I guessed before, it seems to be
> related just to readonly snapshots:
>
> 1) I create a readonly snapshot
> 2) I do some changes on the source subvolume for the snapshot (I'm not
> sure changes are strictly needed)
> 3) reboot (or probably just unmount and remount. I reboot because the
> fs I've problems with contains my root subvolume)
>
> After the rebooting (or the remount) I consistently have the corruption
> with the usual multitude of these in dmesg
> "parent transid verify failed on 902316032 wanted 2484 found 4101"
> and the characteristic ls -la output
>
> drwxr-xr-x 1 root root  250 Oct 10 15:37 root
> d????????? ? ?    ?       ?            ? root-b2
> drwxr-xr-x 1 root root  250 Oct 10 15:37 root-b3
> d????????? ? ?    ?       ?            ? root-backup
>
> root-backup and root-b2 are both readonly whereas root-b3 is rw (and
> it didn't get corrupted).
>
> David, maybe you can try the same steps on one of your machines?
>

Look at that.  I didn't realize it, but indeed I have a corrupted snapshot:
/data/.snapshots/5338/:
ls: cannot access /data/.snapshots/5338/snapshot: Cannot allocate memory
total 4
drwxr-xr-x 1 root root  32 Oct 11 06:09 .
drwxr-x--- 1 root root  32 Oct 11 07:42 ..
-rw------- 1 root root 135 Oct 11 06:09 info.xml
d????????? ? ?    ?      ?            ? snapshot

Several older snapshots are fine, and those predate my 3.17 upgrade.

I noticed that this corrupted snapshot isn't even listed in my snapper lists.

btrfs su delete /data/.snapshots/5338/snapshot
Transaction commit: none (default)
ERROR: error accessing '/data/.snapshots/5338/snapshot'

Removing them appears to be problematic as well.  I might just disable
compress=lzo and go back to 3.16 to see how that goes.

--
Rich
