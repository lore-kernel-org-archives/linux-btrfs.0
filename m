From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: Bug Report - crash copying in large file
Date: Fri, 6 Jun 2008 21:22:51 +1000
Message-ID: <20080606112251.GA20143@brong.net>
References: <20080605041516.GA11964@brong.net> <20080605122509.GA11136@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bron Gondwana <brong@fastmail.fm>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080605122509.GA11136@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 05, 2008 at 08:25:09AM -0400, Chris Mason wrote:
> On Thu, Jun 05, 2008 at 02:15:16PM +1000, Bron Gondwana wrote:
> > Hi, random crash dump if you're interested:
> > 
> > Latest stable btrfs (557:4b7e2b315a32)
> > Latest stable progs (234:e6d157c83cfe)
> > Latest Ubuntu Hardy kernel (2.6.24-28-generic).
> > Ubuntu Hardy toolchain (gcc: 4.2.3-2ubuntu7)
> > 
> > Filesystem was freshly rebuilt about an hour ago.  I rsynced 
> > over my Maildir and associated offlineimap and mutt
> > configurations, had offlineimap syncing mail, mutt reading it
> > and an ~700Mb file being copied in from an NFS mount.
> > 
> > Space - there was about 1.5Gb free when I started the copy.
> > Still, I'm guessing from the dump it may be a disk space issue.
> > 
> 
> Yes, this was definitely an ENOSPC oops.  Sorry, I do plan on starting
> on enospc, it will come right after the tree concurrency.

Hey, I really don't care that much - I have a duplicate sitting on
reiserfs on the next partition over, and rsync frequently enough
that re-fetching from IMAP won't hurt much.

Anything I can do (with my limited FS experience) to help 
with ENOSPC?

Bron.
