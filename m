Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50910 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2LBIt7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Dec 2012 03:49:59 -0500
Received: by mail-ob0-f174.google.com with SMTP id ta14so1613627obb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Dec 2012 00:49:58 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 2 Dec 2012 09:49:57 +0100
Message-ID: <CAHt5hBH6drsjdzudgwgd8hdyRFOXsZqptu3J5y32z=MGxTmhCg@mail.gmail.com>
Subject: [RESEND] btrfs corruption / cannot mount
From: Riccardo Berto <riccardobrt@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi
I'm a btrfs user since I encountered the ext4 3.6.2 bug and then I
decided to switch.

Today I was using my system when the /home btrfs filesystem get
corrupted. I rebooted almost instantly but it couldn't mount /home
(/dev/sda4). So I disabled the /home automount in fstab in order to
have gnome working again and I logged in to freenode on #btrfs channel
for having support.
I met "darksatanic" who gave me suggestions to have /home mounted again.
I tried with him to mount /home manually with -o recovery (it didn't
worked). Then I did btrfs-zero-log /dev/sda4 and then it mounted, but
only a time. There were no files in there: only the dirs mountpoints
to my external HD. So I launched btrfs-restore /dev/sda4 /mnt/ and it
restored only some dotfiles (not all).
He then took me to write to mailing list attaching my logs, hoping for
someone with more clue who can help me.

Now it seems to work fine, I will stick with this fs until your needs
in order to give you logs to better understand what happened.


dmesg containing my try with "recovery" mountflag -->
http://pastebin.com/x1rDsfHu

btrfs-find-root /dev/sda4 log -->http://pastebin.com/WHbDC2xq


--
Linux Registered User (http://linuxcounter.net) #550720
