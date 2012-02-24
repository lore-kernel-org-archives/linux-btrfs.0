From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: Wrong error message when using unknown 2nd subcommand
Date: Fri, 24 Feb 2012 12:54:16 +0200
Message-ID: <20120224105416.GA2023@zambezi.lan>
References: <alpine.LNX.2.01.1202240647260.12486@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1202240647260.12486@frira.zrqbmnf.qr>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 24, 2012 at 06:48:58AM +0100, Jan Engelhardt wrote:
> 
> In btrfsprogs-0.19, using an unknown second argument (fd, misspelled) 
> leads to an error message complaining about the first argument (it 
> should report the second one instead).
> 
> $ btrfs fi df
> ERROR: 'filesystem df' requires 1 arg(s)
> $ btrfs fi fd
> ERROR: unknown command 'fi'

Yep, that's one of the bugs in the current progs parser.  I rewrote it
completely, it's available from the 'parser' branch of Chris'
btrfs-progs repo and should be merged into master shortly.

Thanks,

		Ilya
