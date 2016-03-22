Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:33679 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbcCVUHh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 16:07:37 -0400
Received: by mail-lf0-f53.google.com with SMTP id o73so4719489lfe.0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 13:07:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160322090342.595fefac@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
Date: Tue, 22 Mar 2016 21:07:35 +0100
Message-ID: <CAPmG0jY5EW3SXymZOCSFw2A-d2HrQ4tyFDESktqui5D8_H6noQ@mail.gmail.com>
Subject: Re: csum errors in VirtualBox VDI files
From: Henk Slager <eye1tm@gmail.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 22, 2016 at 9:03 AM, Kai Krakow <hurikhan77@gmail.com> wrote:
> Hello!
>
> Since one of the last kernel updates (I don't know which exactly), I'm
> experiencing csum errors within VDI files when running VirtualBox. A
> side effect of this is, as soon as dmesg shows these errors, commands
> like "du" and "df" hang until reboot.
>
> I've now restored the file from backup but it happens over and over
> again.
>
> On another machine I'm also seeing errors with big files in the
> following scenario (apparently an older kernel, 4.1.x I afair):
>
> # ntfsclone --save /dev/md126p2 -o rescue.ntfs.img
>                    ^ big NTFS partition   ^ file on btrfs
>
> results in a write error and the file system goes read-only.
>
> Both systems have in common they are using btrfs on bcache with
> compress=lzo,autodefrag,nossd,discard (mraid=1,draid=0 and
> mraid=1,draid=single).

autodefrag,nossd:  I am using these too on bcached btrfs, so far no
issues (including kernel 4.5.0). I have been writing bigfiles (> 50G)
without problems.
compress=lzo: I have used it on bcached btrfs in the past, worked fine
discard: I am not sure what this should do on top of /dev/bcacheX ; I
don't know how this relates to the bcache discard; I currently have
bcache setting:  Discard?  False

I am not saying that the last mount option is the direct cause of the
problems you experience, it is just that I don't know its impact
currently.

> The system mentioned first is running Kernel 4.5.0 with Gentoo
> patch-set. I upgraded from the last 4.4.x kernel when I first
> experienced this problem. The first time the problem resulted in a
> duplicate extent which btrfsck wasn't able to fix, that's when I first
> restored from backup. But now I'm getting csum errors in this file over
> a over again, plus when rsync has run for backup, the system no longer
> responds to "du" and "df" commands - it just hangs.
>
> Known problem? Does it help if I send debug info? If so, please
> instruct.
>
> --
> Regards,
> Kai
>
> Replies to list-only preferred.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
