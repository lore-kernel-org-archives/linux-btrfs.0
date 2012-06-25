Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:45680 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2FYTKn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 15:10:43 -0400
Date: Mon, 25 Jun 2012 15:10:40 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: fio reports data corruption with btrfs
Message-ID: <20120625191039.GE7404@localhost.localdomain>
References: <CAHf9xvafQugP2c_3_rxNAn55TgF_GiCM7udNS6yLEqVfPD1_wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAHf9xvafQugP2c_3_rxNAn55TgF_GiCM7udNS6yLEqVfPD1_wg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2012 at 12:30:34PM -0600, Alex Lyakas wrote:
> Greetings everybody,
> 
> I am running a fio test on btrfs compiled from
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git,
> up to commit:
> cb77fcd88569cd2b7b25ecd4086ea932a53be9b3 Btrfs: delay iput with async extents
> including this commit.
> 
> Below is a fio configuration file, and later fio textual output.
> Here:
> https://docs.google.com/folder/d/0B1AuaIB8xZtbNTRuSW1zVGozWFE/edit
> are "expected" vs "received" mismatch reports. Strangely, when I read
> the mismatched block from the file reported as corrupted by fio, I
> receive data different both from "expected" and "received" blocks that
> fio reports. I added one such file (job0.1.0.88576.now) to the
> pastebin as well.
> 
> If you think that my fio configuration file is faulty, please let me
> know. fio version is 1.59. The idea is to run 10 io processes in
> parallel.
> 

Mount options?  I'm running the test now, I'll let you know if I can reproduce.
Thanks,

Josef
