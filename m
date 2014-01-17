Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbaAQPCR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 10:02:17 -0500
Date: Fri, 17 Jan 2014 16:02:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: Tomasz Chmielewski <tch@virtall.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS critical: unable to find logical 0 len 4096, No mapping
 for 0-4096
Message-ID: <20140117150215.GV6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140116062741.2be67c5b@virtall.com>
 <52D77042.3060905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52D77042.3060905@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 16, 2014 at 01:38:10PM +0800, Wang Shilong wrote:
> This problem should be fixed by Filipe, and pused into josef's btrfs-next:-)
> 
> patch url is:
> https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?id=5d157162be99f950a0b64b526c04dff03f8c4eeb

For the recrod, the patch has been tagged for stable and queued for next
merge window, so it'll get into the 3.13.x releases.
