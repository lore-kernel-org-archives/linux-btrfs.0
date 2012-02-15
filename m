From: Timo Nentwig <btrfs@nentwig.biz>
Subject: Re: can't read superblock (but could mount)
Date: Wed, 15 Feb 2012 07:03:49 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1202150701150.24133@localhost>
References: <20120210203051.Horde.q5KnHsL8999PNXBrH5AlxdA@webmail.df.eu> <20120210221842.GU8384@shiny> <20120210233959.GV8384@shiny> <20120211072725.Horde.8iYhMlNNcXdPNgpNS2yG-PA@webmail.df.eu> <20120213130943.GA1573@shiny> <alpine.LNX.2.00.1202141832420.11051@localhost>
 <20120214184131.GZ1573@shiny> <alpine.LNX.2.00.1202141950420.18337@localhost> <20120214211422.GE1573@shiny>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120214211422.GE1573@shiny>
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, 14 Feb 2012, Chris Mason wrote:

> Ok, 3.2 shouldn't have done this.  Was this an external drive?  What
> else do you have on the system?

Nothing special actually. Standard arch linux with virtualbox kernel modules.
It's a SSD if this should matter. Mounted with ssd,compress=lzo,noatime.

> Is this the same FS that was corrupted or a different one?

Different one. Created from an old 3.2.1 gentoo install (btrfs 0.19-dirty).
