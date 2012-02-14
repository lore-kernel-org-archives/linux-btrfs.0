From: Timo Nentwig <btrfs@nentwig.biz>
Subject: Re: can't read superblock (but could mount)
Date: Tue, 14 Feb 2012 19:54:43 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1202141950420.18337@localhost>
References: <20120210203051.Horde.q5KnHsL8999PNXBrH5AlxdA@webmail.df.eu> <20120210221842.GU8384@shiny> <20120210233959.GV8384@shiny> <20120211072725.Horde.8iYhMlNNcXdPNgpNS2yG-PA@webmail.df.eu> <20120213130943.GA1573@shiny> <alpine.LNX.2.00.1202141832420.11051@localhost>
 <20120214184131.GZ1573@shiny>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120214184131.GZ1573@shiny>
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, 14 Feb 2012, Chris Mason wrote:

> As for how we got here, I think you said you were originally running
> something older than 3.2 when these problems started, correct?

Nope, I was already on 3.2.1 or 3.2.4. I restored a backup in the meantime
and already had to soft-reset the box:

# ls -ltr ~/.kde4/share/config/
ls: reading directory /home/foo/.kde4/share/config/: Input/output error

Sigh...
