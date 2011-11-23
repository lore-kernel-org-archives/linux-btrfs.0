From: Sander <sander@humilis.net>
Subject: Re: btrfs encryption problems
Date: Wed, 23 Nov 2011 12:09:57 +0100
Message-ID: <20111123110956.GB31800@attic.humilis.net>
References: <CAAVfQj=O5nDAcgsiNHz3dNXHDerNrq2Jw01WFLJr5q563oZToA@mail.gmail.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: 810d4rk <810d4rk@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAVfQj=O5nDAcgsiNHz3dNXHDerNrq2Jw01WFLJr5q563oZToA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

810d4rk wrote (ao):
> Hi to all, I have a hard drive encrypted using the gnome disk utility
> and it is formated with with btrfs and GUID, the problem started when
> moving a 4gb file to other disk it stooped saying input output error I
> think, then when I tried to access it I entered the password to
> decrypt and it now says that I must specify filesystem type so it
> doesn't recognize the filesystem, I used 3.0 kernel, meanwhile I
> upgraded to 3.1, I have a backup of important files in other disk the
> problem is that it is also encrypted and it has btrfs so I don't touch
> it for now, can anyone help here?

dd that backup disk to another disk, so you have a backup of your
backup, and work with that.

You can also post the dmesg output you get when you mount the broken
filesystem, and ask the experts if it might be worth to try experimental
btrfs.fsck on it.

	Sander

fwiw, I backup to gpg encrypted files stored on ext4 to cope with
regressions in both btrfs and disk encryption.

-- 
Humilis IT Services and Solutions
http://www.humilis.net
