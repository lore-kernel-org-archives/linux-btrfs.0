Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37854 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaFADwH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 23:52:07 -0400
Received: by mail-ob0-f169.google.com with SMTP id vb8so3312534obc.14
        for <linux-btrfs@vger.kernel.org>; Sat, 31 May 2014 20:52:06 -0700 (PDT)
MIME-Version: 1.0
From: Shaun Reich <sreich@kde.org>
Date: Sat, 31 May 2014 23:51:26 -0400
Message-ID: <CADVynFArng7kg9vgaeus_FbsQXXVUZa6kcNBYHxLER2RSbfPbQ@mail.gmail.com>
Subject: superblock corruption, cannot obtain data
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

at some point, my /home randomly(?) went into -ro as i noticed writes
were not working. Checked dmesg which had some backtraces which i
ignored. So I simply rebooted, only to find out it wouldn't come back.

so now my /home is stuck on here, I was literally going to do my round
of backups tonight. It's not extremely critical..but to reproduce my
data it'll still be several hours of lost time..and the annoyances of
redoing it.

mounting results in this, as below. mounting recovery doesn't help.
mounting ro recovery doesn't help. btrfs fsck basically reaffirms what
I know so far, that I'm screwed because my superblock is bad.

show super: http://pastie.org/private/b1k2famcfmtquaqgpyfozg
mount dmesg: http://pastie.org/private/8zsczfustrmeg6a2bbfxag

btrfs-find-root: http://bpaste.net/show/326346

it's a 250gb fs.

so, how can i (a) extract my data, (b) try to get it working again,
without needing to redo the filesystem?

I could not understand how to use btrfs-recover with my problem. It
mostly seems to hate me because of said superblock issue.

I wasn't aware that the superblock was extremely critical (surely one
can recreate such data from existing data, theoretically?)

need any other info, just ask.

(please keep me cc'd, not sub'ed)


-- 
Shaun Reich,
KDE Software Developer (kde.org)
