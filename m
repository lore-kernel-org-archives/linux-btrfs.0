From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: minor ID for btrfs-control
Date: Sat, 2 Apr 2011 19:29:36 +0200
Message-ID: <20110402172936.GA24370@mother.jarsat.pl>
References: <Bj4lB4gT1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bj4lB4gT1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 02, 2011 at 06:45:00PM +0200, Helmut Hullen wrote:
> if I've understood some mails in this list correct, then btrfs needs a  
> character device "btrfs-control"  with the ID 10:55
> 
> When I look for this device in
> 
>         /sys/class/misc/btrfs-control/dev
> 
> I see 10:234
> Kernel 2.6.38.1 (self made), no udev, no initrd, no tempfs. btrfs from  
> nov. 2010
> What goes wrong?


  No udev is wrong.  Modern Linux kernels allocate minor devices dynamically.
If you do not use udev, you need to synchronise /dev/ node with /sys/class/misc/btrfs-control/dev
manually on each boot.

-- 
Tomasz Torcz       ,,(...) today's high-end is tomorrow's embedded processor.''
xmpp: zdzichubg@chrome.pl                      -- Mitchell Blank on LKML

