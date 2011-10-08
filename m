From: Josef Bacik <josef@redhat.com>
Subject: Re: fixing slow sync(2)
Date: Sat, 8 Oct 2011 11:35:54 -0400
Message-ID: <20111008153553.GA25337@dhcp231-156.rdu.redhat.com>
References: <4E906B1F.6010609@dbservice.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tomas Carnecky <tom@dbservice.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E906B1F.6010609@dbservice.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 08, 2011 at 05:24:15PM +0200, Tomas Carnecky wrote:
> The issue with sync(2) being slow has been known for a while now (I can  
> find discussions as early as July 2010). But nobody seems to be willing  
> to fix it or even figure out out what the actual problem is. I use btrfs  
> on two hosts, and the sync(2) syscall is consistently slow. By slow I  
> mean 20 seconds on one and 45(!) seconds on the other. Every single  
> time, no exceptions.
>
> Is there anything I can do to help track down the cause? I can test  
> patches, trace the kernel or use whatever tool is most helpful.
>

I think I fixed this, try my git tree

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git

Let me know if it helps.  And what are you doing when you call sync?  I've not
been able to reproduce this problem so I'm having a hard time nailing down what
it is, so if I can get a reliable way to reproduce it I'll try and figure it
out.  Thanks,

Josef
