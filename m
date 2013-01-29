Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:22606 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab3A2JHe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 04:07:34 -0500
Message-ID: <51079151.4070905@jan-o-sch.net>
Date: Tue, 29 Jan 2013 10:07:29 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, Arne Jansen <sensille@gmx.net>,
        Alexander Block <ablock84@googlemail.com>
Subject: Re: backref for an extent not found in send_root (!backref_ctx->found_itself)
References: <CAOcd+r36TOugPs+5P3W6v6m5pzojGnqZ3YUNS-zzFK2pdm1A8A@mail.gmail.com>
In-Reply-To: <CAOcd+r36TOugPs+5P3W6v6m5pzojGnqZ3YUNS-zzFK2pdm1A8A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

On Mon, January 28, 2013 at 17:11 (+0100), Alex Lyakas wrote:
> Hi Jan,
> I have a set of unit tests (part of the larger system) for the
> send-receive functionality, with which I am able to hit this error:
> 
> Jan 28 18:01:00 687-dev kernel: [16968.451358] btrfs: ERROR did not
> find backref in send_root. inode=259, offset=139264, disk_byte=4263936
> found extent=4263936
> 
> As the code states, this could indicate a bug in backref walking. This
> reproduces with "for-linus" branch.
> 
> Typically this happens when a snapshot is deleted, immediately a new
> snap with the same name is created, and then "btrfs send" is issued
> without parent (i.e., full-send) on this snap.
> 
> To debug this further, we can do one of two things:
> # I can apply patches/debug prints & reproduce
> # I can work to isolate the unit test into a bash script and send you
> a script that reproduces

I'd prefer #2 of the above. You can also send me the unit tests you've got if I
can get them running without multiple days of setup.

I'm guessing that this is more likely going to end up in send.c than in
backref.c, perhaps Alexander would like to trace this one down. But anyway, send
me a reproducer (in private, if you don't want to publish it) and we'll see
what's going on.

Thanks,
-Jan
