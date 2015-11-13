Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293AbbKMP6Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 10:58:16 -0500
Date: Fri, 13 Nov 2015 16:56:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Michael Lass <bevan@bi-co.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs: increase buffer size in is_ssd
Message-ID: <20151113155639.GM6445@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1446996783-25363-1-git-send-email-bevan@bi-co.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446996783-25363-1-git-send-email-bevan@bi-co.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 08, 2015 at 04:33:03PM +0100, Michael Lass wrote:
> In current versions of util-linux the buffer passed to blkid_devno_to_wholedisk
> has to be sufficiently large to not only hold the device name but the complete
> target of the /sys/dev/block/<maj:min> symlink. This was changed only recently
> in 4419ffb9eff5801fdbd385a4a6199b3877f802ad.
> 
> The small buffer size currently can lead to failure of is_ssd due to truncated
> device names:
> 
> readlink("/sys/dev/block/254:7", "../../devices/virtual/block/dm-", 31) = 31
> open("/sys/block/dm-/queue/rotational", O_RDONLY) = -1 ENOENT (No such file or directory)
> 
> Signed-off-by: Michael Lass <bevan@bi-co.net>

Applied, thanks.
