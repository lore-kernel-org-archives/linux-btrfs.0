Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35745 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbcG3UCT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jul 2016 16:02:19 -0400
Received: by mail-oi0-f51.google.com with SMTP id l72so147963339oig.2
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jul 2016 13:02:18 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 30 Jul 2016 14:02:17 -0600
Message-ID: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
Subject: systemd KillUserProcesses=yes and btrfs scrub
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Short version: When systemd-logind login.conf KillUserProcesses=yes,
and the user does "sudo btrfs scrub start" in e.g. GNOME Terminal, and
then logs out of the shell, the user space operation is killed, and
btrfs scrub status reports that the scrub was aborted. [1]

I think what's going on is the user space stuff is what's tracking the
status and statistics, so when that process goes to status Z on
logout, all of that accounting stops. But I can't tell if the kernel
scrub code finishes. Those threads continue some time after btrfs user
space process goes Z, but seems like not quite long enough to actually
finish the scrub.

Neither 'btrfs balance &' (I have not tried the background balance
code in progs 4.7) nor 'btrfs replace start' appear to be likewise
affected. The user process remains after logout and the task appears
to complete without problems. So at the moment I'm only thinking scrub
is affected, but I'm not sure why.


[1]
systemd KillUserProcesses=yes and btrfs scrub
https://bugzilla.kernel.org/show_bug.cgi?id=150781


-- 
Chris Murphy
