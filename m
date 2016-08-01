Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33774 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbcHASG7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 14:06:59 -0400
Received: by mail-oi0-f45.google.com with SMTP id j185so203093326oih.0
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Aug 2016 11:06:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTXNAC1aNpwmhMYYct2GVFO9syFom34XYwM9rGSB5xCJA@mail.gmail.com>
References: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
 <CAJCQCtQ8yPQf8O2LA92-Gd95GGXQiDp-ZomKZgP4bNv-MmKHYw@mail.gmail.com>
 <ac28e105-f228-de18-08c2-e504e304052d@gmail.com> <CAJCQCtQahbHJhcyKrdRGLNuzbd7MUL11nGBpiQ2U40nAn1ve2w@mail.gmail.com>
 <a582564a-e991-dd35-721f-31c807a24929@gmail.com> <CAJCQCtRgmfWVf9YB2=fVLDSRhm4-t7W+YHBabBaBsBZeSiDU1Q@mail.gmail.com>
 <ad6d5637-7d38-8527-513c-ffe000e5a2f1@gmail.com> <CAJCQCtQtxVOZ=7Phc=mjTbGbL+V5hMsjTL3vssJXH0pVZ2xrEg@mail.gmail.com>
 <66ae3161-b57e-e531-36d5-afc726912563@gmail.com> <CAJCQCtTXNAC1aNpwmhMYYct2GVFO9syFom34XYwM9rGSB5xCJA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 1 Aug 2016 12:00:50 -0600
Message-ID: <CAJCQCtSisvQVVgNC-vzWzQ3yKK100wF76Zd2+j3h-ryw=1yEkA@mail.gmail.com>
Subject: Re: systemd KillUserProcesses=yes and btrfs scrub
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Aug 01 09:29:59 localhost.localdomain sudo[1875]:    chris : TTY=pts/1
; PWD=/home/chris ; USER=root ; COMMAND=/sbin/btrfs scrub start /mnt/x
Aug 01 09:30:16 localhost.localdomain systemd[1]: user@1000.service:
Killing process 1883 (btrfs) with signal SIGKILL.
Aug 01 09:43:34 localhost.localdomain sudo[2574]:    chris : TTY=pts/1
; PWD=/home/chris ; USER=root ; COMMAND=/sbin/btrfs scrub start /mnt/x
Aug 01 09:43:53 localhost.localdomain systemd[1]: user@1000.service:
Killing process 2579 (btrfs) with signal SIGKILL.
Aug 01 11:41:00 localhost.localdomain sudo[3479]:    chris : TTY=pts/1
; PWD=/home/chris ; USER=root ; COMMAND=/sbin/btrfs fi show
Aug 01 11:41:04 localhost.localdomain sudo[3492]:    chris : TTY=pts/1
; PWD=/home/chris ; USER=root ; COMMAND=/sbin/btrfs balance start
/mnt/x
Aug 01 11:41:14 localhost.localdomain kernel: BTRFS info (device vdb):
relocating block group 24800919552 flags 130
Aug 01 11:41:14 localhost.localdomain kernel: BTRFS info (device vdb):
relocating block group 23727177728 flags 132
Aug 01 11:41:14 localhost.localdomain kernel: BTRFS info (device vdb):
found 6 extents
Aug 01 11:41:14 localhost.localdomain kernel: BTRFS info (device vdb):
relocating block group 21512585216 flags 129
Aug 01 11:41:24 localhost.localdomain kernel: BTRFS info (device vdb):
found 27447 extents
Aug 01 11:41:26 localhost.localdomain kernel: BTRFS info (device vdb):
found 27446 extents
Aug 01 11:41:26 localhost.localdomain kernel: BTRFS info (device vdb):
relocating block group 19365101568 flags 129
Aug 01 11:41:36 localhost.localdomain systemd[1]: user@1000.service:
Killing process 3499 (btrfs) with signal SIGKILL.


It's using SIGKILL. The process goes Z for scrub but nothing happens
for balance. Weird. It's definitely not exempt though. Hmm, when I
don't filter the journal for btrfs...

Aug 01 11:54:38 localhost.localdomain systemd[3623]: Starting Exit the
Session...
Aug 01 11:54:38 localhost.localdomain systemd[3623]: Received
SIGRTMIN+24 from PID 4269 (kill).
Aug 01 11:54:38 localhost.localdomain systemd[1]: user@1000.service:
Killing process 4206 (sudo) with signal SIGKILL.
Aug 01 11:54:38 localhost.localdomain systemd[1]: user@1000.service:
Killing process 4213 (btrfs) with signal SIGKILL.
Aug 01 11:54:38 localhost.localdomain systemd[1]: Stopped User Manager
for UID 1000.
Aug 01 11:54:38 localhost.localdomain audit[1]: SERVICE_STOP pid=1
uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0
msg='unit=user@1000 comm="systemd" exe="/usr/lib/systemd/systemd"
hostname=? addr=? terminal=? res=success'
Aug 01 11:54:38 localhost.localdomain systemd[1]: Removed slice User
Slice of chris.

In this case PID 4213 is the process that's still flipping between
status R and D. Kill is sent, but ignored. But not for scrubbing...


Aug 01 11:58:21 localhost.localdomain systemd[4294]: Starting Exit the
Session...
Aug 01 11:58:21 localhost.localdomain systemd[4294]: Received
SIGRTMIN+24 from PID 4933 (kill).
Aug 01 11:58:21 localhost.localdomain systemd[4301]:
pam_unix(systemd-user:session): session closed for user chris
Aug 01 11:58:21 localhost.localdomain systemd[1]: user@1000.service:
Killing process 4866 (btrfs) with signal SIGKILL.
Aug 01 11:58:21 localhost.localdomain systemd[1]: Stopped User Manager
for UID 1000.
Aug 01 11:58:21 localhost.localdomain audit[1]: SERVICE_STOP pid=1
uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0
msg='unit=user@1000 comm="systemd" exe="/usr/lib/systemd/systemd"
hostname=? addr=? terminal=? res=success'
Aug 01 11:58:21 localhost.localdomain systemd[1]: Removed slice User
Slice of chris.


Must have something to do with the use of & with balance, which scrub
doesn't need to go to the background.




Chris Murphy
