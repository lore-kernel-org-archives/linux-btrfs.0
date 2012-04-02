From: Dave Jones <davej@redhat.com>
Subject: Re: btrfs io errors on 3.4rc1
Date: Mon, 2 Apr 2012 17:16:22 -0400
Message-ID: <20120402211622.GA2487@redhat.com>
References: <20120402180214.GA1830@redhat.com>
 <20120402194814.GA10965@shiny.msi.event>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120402194814.GA10965@shiny.msi.event>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 02, 2012 at 03:48:14PM -0400, Chris Mason wrote:
 > On Mon, Apr 02, 2012 at 02:02:14PM -0400, Dave Jones wrote:
 > > Updated to rc1 this morning, and my machines with btrfs are all freaking out..
 > > 
 > > I got this from my cron email ..
 > > 
 > > /etc/cron.daily/prelink: line 41: /var/lib/prelink/full: Input/output error
 > > cp: cannot create regular file `/var/lib/prelink/quick': Input/output error
 > > /etc/cron.daily/prelink: line 45: /var/log/prelink/prelink.log: Input/output error
 > 
 > That's not good.  Can you please try my for-linus branch against 3.3?
 > That will rules out all the shiny new btrfs code.
 > 
 > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
 > 
 > -chris

Broken.

(17:14:52:davej@dhcp-189-232:~)$ fsx foo
truncating to largest ever: 0x13e76
truncating to largest ever: 0x2e52c
ftruncate1: 2e52c
dotruncate: ftruncate: Input/output error
Segmentation fault (core dumped)

	Dave
