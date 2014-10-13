Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:57881 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaJMUsN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 16:48:13 -0400
Received: by mail-lb0-f176.google.com with SMTP id p9so6981046lbv.7
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 13:48:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <543C35C3.9070002@prnet.org>
References: <543450DC.90504@prnet.org>
	<1412714780.2374.0@mail.thefacebook.com>
	<543A61EE.7070200@prnet.org>
	<CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>
	<543C35C3.9070002@prnet.org>
Date: Mon, 13 Oct 2014 22:48:12 +0200
Message-ID: <CANg_oxytS04xrVLfWzgz7sJZBArJ-HM8nGADF+ujjRy8heYjqQ@mail.gmail.com>
Subject: Re: btrfs random filesystem corruption in kernel 3.17
From: john terragon <jterragon@gmail.com>
To: David Arendt <admin@prnet.org>
Cc: Rich Freeman <r-btrfs@thefreemanclan.net>, Chris Mason <clm@fb.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think I just found a consistent simple way to trigger the problem
(at least on my system). And, as I guessed before, it seems to be
related just to readonly snapshots:

1) I create a readonly snapshot
2) I do some changes on the source subvolume for the snapshot (I'm not
sure changes are strictly needed)
3) reboot (or probably just unmount and remount. I reboot because the
fs I've problems with contains my root subvolume)

After the rebooting (or the remount) I consistently have the corruption
with the usual multitude of these in dmesg
"parent transid verify failed on 902316032 wanted 2484 found 4101"
and the characteristic ls -la output

drwxr-xr-x 1 root root  250 Oct 10 15:37 root
d????????? ? ?    ?       ?            ? root-b2
drwxr-xr-x 1 root root  250 Oct 10 15:37 root-b3
d????????? ? ?    ?       ?            ? root-backup

root-backup and root-b2 are both readonly whereas root-b3 is rw (and
it didn't get corrupted).

David, maybe you can try the same steps on one of your machines?

John
