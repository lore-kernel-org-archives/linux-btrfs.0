From: Tom Kuther <kuther@gmx.de>
Subject: Re: Fsck, parent transid verify failed
Date: Sun, 12 Dec 2010 12:21:27 +0100
Message-ID: <20101212122127.0befdac2@gimpel.ath.cx>
References: <003501cb9147$09197540$1b4c5fc0$@gmail.com>
	<1291306826-sup-7837@think>
	<AANLkTim5-5KQ3_sEb9WY+O1Uj36=3M3i_yQKeuSb7Qe5@mail.gmail.com>
	<1291326502-sup-1726@think>
	<loom.20101209T171330-48@post.gmane.org>
	<1292011722-sup-5780@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1292011722-sup-5780@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fr, 10.12.10 15:11 Chris Mason <chris.mason@oracle.com> wrote:

> > What would be the steps to get it mounted?
> 
> If btrfsck -s is able to find a good super, I've setup a tool that
> will copy the good super over into the default super.  It is currently
> sitting in the next branch of the btrfs-progs-unstable repo.
> 
> git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
> next
> 
> (or git pull into your existing checkout)
> 
> Then
> 
> make btrfs-select-super
> ./btrfs-selects-super -s 1 /dev/xxx
> 
> After this you'll want to do a full backup and make sure things are
> working properly.
> 
> -chris

This worked fine. I was able to mount and completely read it.
The volume seems healthy and is fully usable so far.

Thanks a lot!

~thomas
