Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserverfr1.prnet.org ([188.165.43.41]:44897 "EHLO
	extserverfr1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaJLVfT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Oct 2014 17:35:19 -0400
Message-ID: <543AF411.3090408@prnet.org>
Date: Sun, 12 Oct 2014 23:35:13 +0200
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: john terragon <jterragon@gmail.com>
CC: Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send and kernel 3.17
References: <543450DC.90504@prnet.org>	<1412714780.2374.0@mail.thefacebook.com>	<543A61EE.7070200@prnet.org> <CANg_oxzGu3SB4Es5tdB4+zsYJ231eWo878XUVPFcoRFM5wNBzA@mail.gmail.com>
In-Reply-To: <CANg_oxzGu3SB4Es5tdB4+zsYJ231eWo878XUVPFcoRFM5wNBzA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just to let you know, I just tried an ls -l on 2 machines running kernel
3.17 and btrfs-progs 3.16.2.

Here is my ls -l output:

Machine 1:
ls: cannot access root.20141009.000503.backup: Cannot allocate memory
total 0
d????????? ? ?      ?         ?            ? root.20141009.000503.backup
drwxr-xr-x 1 root   root    182 Oct  7 20:35 root.20141012.095526.backup
drwxr-xr-x 1 root   root    182 Oct  7 20:35 root.20141012.000503.backup
drwxr-xr-x 1 root   root    182 Oct  7 20:35 root.20141011.000502.backup
drwxr-xr-x 1 root   root    182 Oct  7 20:35 root.20141010.000502.backup

root.20141009.000503.backup is not deletable.

Machine 2:
ls: cannot access root.20141006.003239.backup: Cannot allocate memory
ls: cannot access root.20141007.001616.backup: Cannot allocate memory
ls: cannot access root.20141008.000501.backup: Cannot allocate memory
ls: cannot access root.20141009.052436.backup: Cannot allocate memory
total 0
d????????? ? ?    ?      ?            ? root.20141009.052436.backup
d????????? ? ?    ?      ?            ? root.20141008.000501.backup
d????????? ? ?    ?      ?            ? root.20141007.001616.backup
d????????? ? ?    ?      ?            ? root.20141006.003239.backup
drwxr-xr-x 1 root root 232 Aug  3 15:00 root.20140925.001125.backup
drwxr-xr-x 1 root root 232 Aug  3 15:00 root.20140924.001017.backup
drwxr-xr-x 1 root root 232 Aug  3 15:00 root.20140923.001008.backup
drwxr-xr-x 1 root root 232 Aug  3 15:00 root.20140922.001836.backup
drwxr-xr-x 1 root root 232 Aug  3 15:00 root.20140921.001029.backup
drwxr-xr-x 1 root root 232 Aug  3 15:00 root.20140920.001020.backup

The ? ones are also not deletable.

Both machines are giving transid verify failed errors.

I verified my logfiles and this problem was never there using previous
kernel versions. On machine 1, it is also sure that it was not any
previous corruption as this filesystem has also been created with
btrfs-progs 3.16.2 using kernel 3.17.

On 10/12/2014 05:24 PM, john terragon wrote:
> Hi.
>
> I just wanted to "confirm David's story" so to speak :)
>
> -kernel 3.17-rc7 (didn't bother to compile 3.17 as there weren't any
> btrfs fixes, I think)
>
> -btrfs-progs 3.16.2 (also compiled from source, so no
> distribution-specific patches)
>
> -fresh fs
>
> -I get the same two errors David got (first I got the I/O error one
> and then the memory allocation one)
>
> -plus now when I ls -la the fs top volume this is what I get
>
> drwxrwsr-x 1 root staff  30 Sep 11 16:15 home
> d????????? ? ?    ?       ?            ? home-backup
> drwxr-xr-x 1 root root  250 Oct 10 15:37 root
> d????????? ? ?    ?       ?            ? root-backup
> drwxr-xr-x 1 root root   88 Sep 15 16:02 vms
> drwxr-xr-x 1 root root   88 Sep 15 16:02 vms-backup
>
> yes, the question marks on those two *-backup snapshots are really
> there. I can't access the snapshots, I can't delete them, I can't do
> anything with them.
>
> -btrfs check segfaults
>
> -the events that led to this situation are these:
>  1) btrfs su snap -r root root-backup
>  2) send |receive (the entire root-backup, not and incremental send)
>      immediate I/O error
>  3) move on to home: btrfs su snap -r home home-backup
>  4) send|receive (again not an incremental send)
>      everything goes well (!)
>  5) retry with root: btrfs su snap -r root root-backup
>  6) send|receive
>      and it goes seemingly well
>  7) apt-get dist-upgrade just to modify root and try an incremental send
>  8) reboot after the dist-upgrade
>  9) ls -la the fs top volume: first I get the memory allocation error
> and after that
>        any ls -la gives the output I pasted above. (notice that beside
> the ls -la, the
>        two snapshots were not touched in any way since the two send|receive)
>
> Few final notes. I haven't tried send/receive in a while (they were
> unreliable) so I can't tell which is the last version they worked for
> me (well, no version actually :) ).
> I've never had any problem with just snapshots. I make them regularly,
> I use them, I modify them and I've never had one problem (with 3.17
> too, it's just send/receive that murders them).
>
> Best regards
>
> John

