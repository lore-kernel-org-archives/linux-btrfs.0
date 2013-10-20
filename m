Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39782 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3JTKeR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Oct 2013 06:34:17 -0400
Received: by mail-qa0-f53.google.com with SMTP id k15so1812712qaq.12
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Oct 2013 03:34:17 -0700 (PDT)
MIME-Version: 1.0
From: Phil Davis <pmdhazy@gmail.com>
Date: Sun, 20 Oct 2013 11:33:56 +0100
Message-ID: <CAERquQ78pOig3oQoom2e0Jcsv1i3-_8ET0ewAWUUo+nt2vk4Mg@mail.gmail.com>
Subject: btrfs send 'leaks' open files
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Setup:
Fedora 19 with kernel 3.11.4-201.fc19.x86_64
btrfs-progs-0.20.rc1.20130917git194aa4a-1.fc19.x86_64

I am trying to do an initial btrfs send of a large (206GB, 1392221
paths) snapshot to a single file on a
different filesystem (a slow external USB drive with btrfs):

   btrfs send /tank/backups/snapshots/test1 > /extpool/filetest/test5.btr

What happens is eventually get following error in in /var/log/messages:

  VFS: file-max limit 202149 reached

I worked around this by:

echo 900000 > /proc/sys/fs/file-max

but then it hit that so tried 1800000 and left it running. This
produced a 377GB test5.btr file
before system ran out of memory and crashed (oom killer etc.)

This is reproducible but the btrfs send takes about 6+ hours (USB 3.0
card on order...)

The reason I think btrfs send is leaking open files is if you watch
/proc/sys/fs/file-nr you see the
number of open files increasing  but if you kill the btrfs send
process then the open
files count reduces back down.  In fact suspending the process also
reduces the open file count but
resuming it then makes the count start increasing again.

I also found Robert Buhren reporting very similar issue back in April 2013:
http://comments.gmane.org/gmane.comp.file-systems.btrfs/24795

If further information is needed, i'd be happy to help.

-- 
Phil Davis
