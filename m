From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: Re: Restoring BTRFS partition
Date: Tue, 20 Apr 2010 20:32:15 -0400
Message-ID: <20100421003045.GA10361@flcl.lan>
References: <w2y8c113a261004200756ucfa2eeabk617da0fc90d6ed8a@mail.gmail.com>
 <20100420155538.GB3634@laptop.oracle.com>
 <20100420165049.GA6352@flcl.lan>
 <r2x8c113a261004201014v71b6bf3dy9535bb9ac2035d6e@mail.gmail.com>
 <r2o8c113a261004201113gf771574eu35db1b0d916cdfd8@mail.gmail.com>
 <20100420203017.GA4532@lelouch.nomadic.ncsu.edu>
 <q2u8c113a261004201525kebe2462agaca1d5fb81773cef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wengang Wang <wen.gang.wang@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Alli Quaknaa <alquaknaa@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <q2u8c113a261004201525kebe2462agaca1d5fb81773cef@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 20, 2010 at 10:25:34PM +0000, Alli Quaknaa wrote:
> I think I have found the real superblock you are talking about, but
> I'm afraid I may have written something in the first 64MiB. Is there a
> chance btrfsck will recover it?
btrfsck is currently very limited; it only detects a limited number of
problems, and it can't fix anything. Btrfs focuses on handling problems
when they are discovered while using the FS; generally, it should handle
corruption relatively gracefully. However, if anything really crucial
was overwritten and the FS can't be mounted, there aren't any tools to
repair it.

> Also, I think there's gotta be a better way to manipulate those huge
> files then dd and hexedit for examination - I'd like to take the raw
> file, open it in some hex editor and be able to cut of some of it's
> beginning - I can't seem to be able to do it with hexedit. Is there a
> tool you'd recomment?
For viewing, you can use less, head, and tail with hexdump:
    tail -c +$((0x10000+1)) /dev/sda1|hexdump -C|less
will view the disk starting at the superblock. For editing, dd is
probably best, though you could use a hex editor like Okteta. I've also
heard of Radare, supposedly a very advanced command-line tool. Keep in
mind that any tool that deletes the first part of a huge file will be
forced to rewrite the entire file.
