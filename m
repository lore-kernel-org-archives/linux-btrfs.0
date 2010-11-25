From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: VFS support for fast copy on deduplicating FSes
Date: Thu, 25 Nov 2010 11:32:59 +0100
Message-ID: <20101125103258.GA16562@mother.pipebreaker.pl>
References: <AANLkTinz17SePZCCixBCA_WoW3rFWAsB7mRghL9uN17h@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinz17SePZCCixBCA_WoW3rFWAsB7mRghL9uN17h@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 25, 2010 at 04:19:17AM -0600, David Nicol wrote:
> unresearched question/suggestion:
> 
> Is there general support for a "fast copy" ioctl in the VFS layer,
> which would be hooked by file systems that support COW or other forms
> of deduplication and can provide copy semantics by manipulating
> metadata only?
> 

  Yes, see reflink(2) syscall (http://lwn.net/Articles/331576/).

-- 
Tomasz Torcz                "Funeral in the morning, IDE hacking
xmpp: zdzichubg@chrome.pl    in the afternoon and evening." - Alan Cox

