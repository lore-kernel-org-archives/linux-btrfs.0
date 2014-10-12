Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:50494 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaJLPYR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Oct 2014 11:24:17 -0400
Received: by mail-lb0-f178.google.com with SMTP id w7so5282699lbi.23
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Oct 2014 08:24:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <543A61EE.7070200@prnet.org>
References: <543450DC.90504@prnet.org>
	<1412714780.2374.0@mail.thefacebook.com>
	<543A61EE.7070200@prnet.org>
Date: Sun, 12 Oct 2014 17:24:15 +0200
Message-ID: <CANg_oxzGu3SB4Es5tdB4+zsYJ231eWo878XUVPFcoRFM5wNBzA@mail.gmail.com>
Subject: Re: btrfs send and kernel 3.17
From: john terragon <jterragon@gmail.com>
To: David Arendt <admin@prnet.org>
Cc: Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I just wanted to "confirm David's story" so to speak :)

-kernel 3.17-rc7 (didn't bother to compile 3.17 as there weren't any
btrfs fixes, I think)

-btrfs-progs 3.16.2 (also compiled from source, so no
distribution-specific patches)

-fresh fs

-I get the same two errors David got (first I got the I/O error one
and then the memory allocation one)

-plus now when I ls -la the fs top volume this is what I get

drwxrwsr-x 1 root staff  30 Sep 11 16:15 home
d????????? ? ?    ?       ?            ? home-backup
drwxr-xr-x 1 root root  250 Oct 10 15:37 root
d????????? ? ?    ?       ?            ? root-backup
drwxr-xr-x 1 root root   88 Sep 15 16:02 vms
drwxr-xr-x 1 root root   88 Sep 15 16:02 vms-backup

yes, the question marks on those two *-backup snapshots are really
there. I can't access the snapshots, I can't delete them, I can't do
anything with them.

-btrfs check segfaults

-the events that led to this situation are these:
 1) btrfs su snap -r root root-backup
 2) send |receive (the entire root-backup, not and incremental send)
     immediate I/O error
 3) move on to home: btrfs su snap -r home home-backup
 4) send|receive (again not an incremental send)
     everything goes well (!)
 5) retry with root: btrfs su snap -r root root-backup
 6) send|receive
     and it goes seemingly well
 7) apt-get dist-upgrade just to modify root and try an incremental send
 8) reboot after the dist-upgrade
 9) ls -la the fs top volume: first I get the memory allocation error
and after that
       any ls -la gives the output I pasted above. (notice that beside
the ls -la, the
       two snapshots were not touched in any way since the two send|receive)

Few final notes. I haven't tried send/receive in a while (they were
unreliable) so I can't tell which is the last version they worked for
me (well, no version actually :) ).
I've never had any problem with just snapshots. I make them regularly,
I use them, I modify them and I've never had one problem (with 3.17
too, it's just send/receive that murders them).

Best regards

John
