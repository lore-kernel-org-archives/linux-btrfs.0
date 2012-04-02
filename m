From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs io errors on 3.4rc1
Date: Mon, 2 Apr 2012 15:48:14 -0400
Message-ID: <20120402194814.GA10965@shiny.msi.event>
References: <20120402180214.GA1830@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120402180214.GA1830@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 02, 2012 at 02:02:14PM -0400, Dave Jones wrote:
> Updated to rc1 this morning, and my machines with btrfs are all freaking out..
> 
> I got this from my cron email ..
> 
> /etc/cron.daily/prelink: line 41: /var/lib/prelink/full: Input/output error
> cp: cannot create regular file `/var/lib/prelink/quick': Input/output error
> /etc/cron.daily/prelink: line 45: /var/log/prelink/prelink.log: Input/output error

That's not good.  Can you please try my for-linus branch against 3.3?
That will rules out all the shiny new btrfs code.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

-chris
