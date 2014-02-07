Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbaBGRyQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 12:54:16 -0500
Date: Fri, 7 Feb 2014 18:54:15 +0100
From: David Sterba <dsterba@suse.cz>
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: integration-20140206 build failure
Message-ID: <20140207175415.GA16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CALOYprUjGn0rEEJAUw+ggnsazL_F5x4KUMCg2n_+ZeAZT=RJ-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALOYprUjGn0rEEJAUw+ggnsazL_F5x4KUMCg2n_+ZeAZT=RJ-w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 07, 2014 at 12:38:22AM +0000, WorMzy Tykashi wrote:
> Building the latest integration snapshot, I get the following failure:
> 
> ----
> ...
>     [CC]     cmds-filesystem.o
> cmds-filesystem.c: In function 'cmd_show':
> cmds-filesystem.c:740:12: error: invalid storage class for function 'cmd_sync'
>  static int cmd_sync(int argc, char **argv)
>             ^
> cmds-filesystem.c:770:12: error: invalid storage class for function

Thanks. A mismerged patch, fixed in next integration.
