From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Bug Report - crash copying in large file
Date: Mon, 9 Jun 2008 06:08:22 -0400
Message-ID: <20080609060822.6a301f59@think.oraclecorp.com>
References: <20080605041516.GA11964@brong.net>
	<20080605122509.GA11136@think.oraclecorp.com>
	<20080606112251.GA20143@brong.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Bron Gondwana <brong@fastmail.fm>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080606112251.GA20143@brong.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 6 Jun 2008 21:22:51 +1000
Bron Gondwana <brong@fastmail.fm> wrote:

> > Yes, this was definitely an ENOSPC oops.  Sorry, I do plan on
> > starting on enospc, it will come right after the tree concurrency.
> 
> Hey, I really don't care that much - I have a duplicate sitting on
> reiserfs on the next partition over, and rsync frequently enough
> that re-fetching from IMAP won't hurt much.
> 
> Anything I can do (with my limited FS experience) to help 
> with ENOSPC?

I'm afraid there isn't a simple solution for enospc, it is going to be
a long process to nail down all the corners.  If you're interested in
projects, http://btrfs.wiki.kernel.org/index.php/Project_ideas is a
better place to start.

-chris
