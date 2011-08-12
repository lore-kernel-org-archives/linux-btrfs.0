From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Getting a lot of fs-generated information to user space
Date: Fri, 12 Aug 2011 11:25:08 -0600
Message-ID: <20110812172508.GB29309@parisc-linux.org>
References: <4E451917.6080306@jan-o-sch.net> <20110812123154.GA29309@parisc-linux.org> <4E453BA5.4090403@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4E453BA5.4090403@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 12, 2011 at 04:41:41PM +0200, Jan Schmidt wrote:
> After thinking twice, this has a drawback: I'd have to track state
> between two read(2) calls, waiting for userspace to "pull" more data.

That should be OK.  You've got filp->private_data to store your state in,
though you'll have to coordinate with btrfs' other use of ->private_data.
Not hard, just a little bit of work.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
