Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbcGRTvv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 15:51:51 -0400
Date: Mon, 18 Jul 2016 12:51:47 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] vfs: allow FILE_EXTENT_SAME (dedupe_file_range) on a
 file opened ro
Message-ID: <20160718195147.GD17171@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1468793618-10496-1-git-send-email-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468793618-10496-1-git-send-email-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 18, 2016 at 12:13:38AM +0200, Adam Borowski wrote:
> Instead of checking the mode of the file descriptor, let's check whether it
> could have been opened rw.  This allows fixing intermittent exec failures
> when deduping a live system: anyone trying to exec a file currently being
> deduped gets ETXTBSY.
> 
> Issuing this ioctl on a ro file was already allowed for root/cap.
> 
> Tested on btrfs and not-yet-merged xfs, as only them implement this ioctl.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
