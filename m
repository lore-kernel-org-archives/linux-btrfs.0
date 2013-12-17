Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:45886 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab3LQSh1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 13:37:27 -0500
Received: by mail-ve0-f175.google.com with SMTP id jx11so4606544veb.34
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 10:37:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131212155720.11479.7400@ret>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com>
	<01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com>
	<CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com>
	<F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com>
	<CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com>
	<B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com>
	<pan$cd4bd$8058fd9d$d320fdd8$6cb46f0f@cox.net>
	<CAK5rZE5oxr381MhwxdgwJs7HHJC2-_Du+N+FzZUAT2vVynuGcw@mail.gmail.com>
	<pan$dd37b$1a442a8d$594e1d2e$ae5b97e3@cox.net>
	<20131212155720.11479.7400@ret>
Date: Tue, 17 Dec 2013 20:37:26 +0200
Message-ID: <CAK5rZE4qXFd_k6Mck7cQuDD2FjvAX6YsAgCaOvCt6AuBPMNRXA@mail.gmail.com>
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/12/13, Chris Mason <clm@fb.com> wrote:
> For me anyway, data=dup in mixed mode is definitely an accident ;)
> I personally think data dup is a false sense of security, but drives
> have gotten so huge that it may actually make sense in a few
> configurations.

Sure, it's not about any security regarding the device.

It's about the capability of recovering from any
bit-rot which can creep into your backups and can be
detected when you need the file after 20-30 generations
of backups which is too late. (Who keeps that much
incremental archive and reads backup logs of millions of
files, regularly?)

> Someone asks for it roughly once a year, so it probably isn't a horrible
> idea.
> -chris

Today, I've brought up an old 2 GB Seagate from the basement.
Literaly, it has been "Rusted". So it deserves the title of
"Spinning Rust" for real. I had no hope whether it would work,
but out of curiosity I plugged it into a USB-IDE box.

It spinned up and wow!; it showed up among the devices.
It had two swap and an ext2 partition. I remembered that it was
one of the disk used for linux installations more than
10 years ago. I mounted it . Most of the files dates back to 2001-07.

They are more than 12 years old and they seem to be intact
with just one inode size missmatch. (See fsck output below).

If there were BTRFS (and -d dup :) ) at the time, now I would
perform a scrub and report the outcome here. Hence,
'Digital Archeology' can surely benefit from Btrfs. :)

PS: And regarding the "SSD data retension debate" this can be an
interesting benchmark for a device whick was kept in an unfavorable
environment.

Regards,
Imran


FSCK output:

fsck from util-linux 2.20.1
e2fsck 1.42.8 (20-Jun-2013)
/dev/sdb3 has gone 4209 days without being checked, check forced.
Pass 1: Checking inodes, blocks, and sizes
Special (device/socket/fifo) inode 82669 has non-zero size.  Fix<y>? yes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

/dev/sdb3: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sdb3: 41930/226688 files (1.0% non-contiguous), 200558/453096 blocks
