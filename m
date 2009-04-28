From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 23:12:56 +0200
Message-ID: <20090428211255.GB13112@cip.informatik.uni-erlangen.de>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <200904281945.10274.hjclaes@web.de> <20090428201619.GK7217@cip.informatik.uni-erlangen.de> <200904282236.07428.hjclaes@web.de> <20090428205242.GA13112@cip.informatik.uni-erlangen.de> <1240952295.15136.73.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Heinz-Josef Claes <hjclaes@web.de>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240952295.15136.73.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> >         - Implement a system call that reports all checksums and unique
> >           block identifiers for all stored blocks.

> This would require storing the larger checksums in the filesystem.  It
> is much better done in the dedup program.

I think I misunderstood something here. I thought the checksums per
block would already be stored somewhere in btrfs?

> >         - Implement another system call that reports all checksums and
> >           unique identifiers for all stored blocks since the last
> >           report. This can be easily implemented:

> This is racey because there's no way to prevent new changes.

I got the point.

> >           Use a block bitmap for every block on the filesystem use one
> >           bit. If the block is modified set the bit to one, when a
> >           bitmap is retrieved simply zero it out:

> >         Assuming a 4 kbyte block size that would mean for a 1 Tbyte
> >         filesystem:

> >         1Tbyte / 4096 / 8 = 32 Mbyte of memory (this should of course
> >         be saved to disk from time to time and be restored on startup).

> Sorry, a 1TB drive is teeny, I don't think a bitmap is practical
> across the whole FS.  Btrfs has metadata that can quickly and easily
> tell you which files and which blocks in which files have changed
> since a given transaction id.  This is how you want to find new
> things.

You're right the bitmap would not scale. So what is missing is a
systemcall to report the changes to userland? (Is this feature used to
generate off-site backups as well?)

> But, the ioctl to actually do the dedup needs to be able to verify a
> given block has the contents you expect it to.  The only place you can
> lock down the pages in the file and prevent new changes is inside the
> kernel.

I totally agree to that. How much time would it consume to implement
such a systemcall?

        Thomas
