From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:149!
Date: Thu, 5 May 2011 13:53:52 -0400
Message-ID: <20110505175351.GC2372@dhcp231-156.rdu.redhat.com>
References: <201105051412.03175.whirm@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: whirm@gmx.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105051412.03175.whirm@gmx.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 05, 2011 at 02:12:03PM +0200, whirm@gmx.com wrote:
> Seems like the mail didn't get trough, trying again with the logfile 
> compressed.
> 
> Thanks, 
> 
> On Wednesday 04 May 2011 20:21:54 you wrote:
> [...]
> > Argh sorry I was looking at the wrong part of that warning.  Can you run
> > with this debug patch and send me the log?  Thanks,
> > 
> > Josef
> 
> I hope that's enough, the log buffer was too small to keep the whole thing.
> 

Hmm I didn't see what I needed, can you do it again and try to get kernel
messages to go to /var/log/messages so you don't have to worry about the log
buffer?  The other option is to setup netconsole which would grab everything.
Thanks,

Josef
