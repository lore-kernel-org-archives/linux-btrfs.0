From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 1/7] btrfs: don't BUG_ON btrfs_alloc_path() errors
Date: Thu, 14 Jul 2011 15:08:41 -0700
Message-ID: <20110714220841.GA6911@wotan.suse.de>
References: <1310680807-13360-1-git-send-email-mfasheh@suse.com> <1310680807-13360-2-git-send-email-mfasheh@suse.com>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310680807-13360-2-git-send-email-mfasheh@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 14, 2011 at 03:00:07PM -0700, Mark Fasheh wrote:
> This patch fixes many callers of btrfs_alloc_path() which BUG_ON allocation
> failure. All the sites that are fixed in this patch were checked by me to
> be fairly trivial to fix because of at least one of two criteria:

Please ignore - these didn't get sent out right, sorry for that. Will resend
ASAP.
	--Mark

--
Mark Fasheh
