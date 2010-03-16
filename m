From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [BUG] scheduling while atomic: init/1/0x00000002
Date: Mon, 15 Mar 2010 20:39:36 -0400
Message-ID: <20100316003936.GB11905@think>
References: <45e1b66a1003131549k28173905r85ab74cd870db36e@mail.gmail.com>
 <93cdabd21003132226s2201c067vfdbcaad56ecffd81@mail.gmail.com>
 <45e1b66a1003151520k2be08f2drb976abdad1ef9006@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Fedyk <mfedyk@mikefedyk.com>, linux-btrfs@vger.kernel.org
To: Phillip Michael <oopsicrappe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <45e1b66a1003151520k2be08f2drb976abdad1ef9006@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 15, 2010 at 03:20:23PM -0700, Phillip Michael wrote:
> >> BUG: scheduling while atomic: init/1/0x00000002
> >> Modules linked in:
> >> Pid: 1, comm: init Not tainted 2.6.33-zen2-20100307-stable #6
> >
> > Can you reproduce this error on stock 2.6.33 without the zen patches?
> >
> 
> I get the same bug on a stock archlinux 2.6.33 kernel. I have to
> finish reinstalling before I can build a vanilla kernel to try.

This definitely looks like a bad interaction between btrfs and
tux-on-ice.  I'll see what I can find, but I wouldn't suspend to disk
until I get it nailed down.

-chris

