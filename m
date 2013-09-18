Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab3IRPSk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 11:18:40 -0400
Date: Wed, 18 Sep 2013 17:18:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] add super-recover tool to recover bad supers
Message-ID: <20130918151838.GE6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 18, 2013 at 04:27:32PM +0800, Wang Shilong wrote:
> Until now if one of device's first superblock is corrupt,btrfs will
> fail to mount. Luckily, btrfs have at least two superblocks for
> every disk.
> 
> This little program will scan devices and find good superblocks
> (max generation, checksum matched). And use this superblock to
> recover bad superblocks.The process is:
> 
> Step1: scan btrfs devices
> Step2: find good supers
> Step3: open ctree
> Step4: writ all supers

Looks great! I'll pull that into integration even with the BUG_ON in the
4/4 patch and will replace it later.

david
