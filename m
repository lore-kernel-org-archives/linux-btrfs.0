Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserverfr1.prnet.org ([188.165.43.41]:44919 "EHLO
	extserverfr1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaJMVYo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 17:24:44 -0400
Message-ID: <543C428B.1020503@prnet.org>
Date: Mon, 13 Oct 2014 23:22:19 +0200
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: john terragon <jterragon@gmail.com>
CC: Rich Freeman <r-btrfs@thefreemanclan.net>, Chris Mason <clm@fb.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs random filesystem corruption in kernel 3.17
References: <543450DC.90504@prnet.org>	<1412714780.2374.0@mail.thefacebook.com>	<543A61EE.7070200@prnet.org>	<CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>	<543C35C3.9070002@prnet.org> <CANg_oxytS04xrVLfWzgz7sJZBArJ-HM8nGADF+ujjRy8heYjqQ@mail.gmail.com>
In-Reply-To: <CANg_oxytS04xrVLfWzgz7sJZBArJ-HM8nGADF+ujjRy8heYjqQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As these to machines are running as server for different purposes (yes,
I know that btrfs is unstable and any corruption or data loss is at my
own risk therefore I have good backups), I want to reboot them not more
then necessary.

However I tried to bring my reboot times in relation with corruptions:

machine 1:

d????????? ? ?      ?         ?            ? root.20141009.000503.backup

reboot   system boot  3.17.0           Thu Oct  9 23:20   still running
reboot   system boot  3.17.0           Tue Oct  7 21:25 - 23:18 (2+01:53)
reboot   system boot  3.17.0           Mon Oct  6 22:47 - 23:18 (3+00:31)

For this machine, corruption seems to have occurred for a snapshot
created after a reboot.


machine 2:

d????????? ? ?    ?      ?            ? root.20141006.003239.backup
d????????? ? ?    ?      ?            ? root.20141007.001616.backup
d????????? ? ?    ?      ?            ? root.20141008.000501.backup
d????????? ? ?    ?      ?            ? root.20141009.052436.backup

reboot   system boot  3.17.0           Thu Oct  9 21:31   still running
reboot   system boot  3.17.0           Tue Oct  7 21:27 - 21:30 (2+00:03)
reboot   system boot  3.17.0           Tue Oct  7 17:51 - 21:26  (03:34)
reboot   system boot  3.17.0           Sun Oct  5 23:50 - 17:50 (1+17:59)
reboot   system boot  3.17.0           Sun Oct  5 23:47 - 23:49  (00:01)

During the next days, I will setup a virtual machine to do more tests.

On 10/13/2014 10:48 PM, john terragon wrote:
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
> John

