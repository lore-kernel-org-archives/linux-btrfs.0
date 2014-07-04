Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbaGDNw2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Jul 2014 09:52:28 -0400
Date: Fri, 4 Jul 2014 15:52:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: Add mount point check for 'btrfs fi df'
 command
Message-ID: <20140704135226.GO1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404463129-28350-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1404463129-28350-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404463129-28350-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 04, 2014 at 04:38:49PM +0800, Qu Wenruo wrote:
> 'btrfs fi df' command is currently able to be executed on any file/dir
> inside btrfs since it uses btrfs ioctl to get disk usage info.
> 
> However it is somewhat confusing for some end users since normally such
> command should only be executed on a mount point.

I disagree here, it's much more convenient to run 'fi df' anywhere and
get the output. The system 'df' command works the same way.

The 'fi df' command itself is not that user friendly and the numbers
need further interpretation. I'm using it heavily during debugging and
restricting it to the mountpoint seems too artifical, the tool can cope
with that.

The 'fi usage' is supposed to give the user-friendly overview, but the
patchset is stuck because I found the numbers wrong or misleading under
some circumstances.

I'll reread the thread that motivated this patch to see if there's
something to address.
