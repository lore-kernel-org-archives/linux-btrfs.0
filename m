From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: kernel BUG at fs/btrfs/inode.c:4676!
Date: Wed, 20 Jul 2011 07:37:50 -0700
Message-ID: <1311172680.7531.18.camel@shinybook.infradead.org>
References: <201106061220.05696.markotahal@gmail.com>
	 <201106102043.19025.markotahal@gmail.com> <4DF28414.8090601@redhat.com>
	 <1340741.hHfqtiVQGn@beruska> <4E0213C8.20006@redhat.com>
	 <1311141916.4652.4.camel@shinybook.infradead.org>
	 <1311150979-sup-1740@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Josef Bacik <josef@redhat.com>,
	Marek Otahal <markotahal@gmail.com>,
	Daniel J Blueman <daniel.blueman@gmail.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Andy Lutomirski <luto@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311150979-sup-1740@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2011-07-20 at 04:44 -0400, Chris Mason wrote:
> Oh, the dirty little secret of loop devices is they don't actually write
> things to disk properly.   They are not power off safe.  But you can
> trigger this without a loop device, correct?

Yes. I would have liked to reproduce it last night and show it to you
this morning, and that way I'd double-check that it really is the *same*
BUG(). But certainly I thought it was a few weeks ago when I looked, and
the bit about having to reboot into 2.6.38 before I can boot 3.0 is
*definitely* the same.

> The oops were hitting is a -EEXIST on trying to insert the directory
> entry for the inode back ref, but the tree-logging stuff is already
> trying to check for dups.
> 
> I'll take a look.

Thanks. I'll *try* to make it happen again, but I haven't managed it so
far... and no, I haven't updated my kernel; this is the *same* kernel
that was doing it before.


