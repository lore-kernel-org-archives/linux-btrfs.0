From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Bug Report - crash copying in large file
Date: Thu, 5 Jun 2008 08:25:09 -0400
Message-ID: <20080605122509.GA11136@think.oraclecorp.com>
References: <20080605041516.GA11964@brong.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Bron Gondwana <brong@fastmail.fm>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080605041516.GA11964@brong.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 05, 2008 at 02:15:16PM +1000, Bron Gondwana wrote:
> Hi, random crash dump if you're interested:
> 
> Latest stable btrfs (557:4b7e2b315a32)
> Latest stable progs (234:e6d157c83cfe)
> Latest Ubuntu Hardy kernel (2.6.24-28-generic).
> Ubuntu Hardy toolchain (gcc: 4.2.3-2ubuntu7)
> 
> Filesystem was freshly rebuilt about an hour ago.  I rsynced 
> over my Maildir and associated offlineimap and mutt
> configurations, had offlineimap syncing mail, mutt reading it
> and an ~700Mb file being copied in from an NFS mount.
> 
> Space - there was about 1.5Gb free when I started the copy.
> Still, I'm guessing from the dump it may be a disk space issue.
> 

Yes, this was definitely an ENOSPC oops.  Sorry, I do plan on starting
on enospc, it will come right after the tree concurrency.

-chris
