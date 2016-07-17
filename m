Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:36837 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbcGQWcd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jul 2016 18:32:33 -0400
Date: Mon, 18 Jul 2016 00:32:27 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Mark Fasheh <mfasheh@suse.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] vfs: allow FILE_EXTENT_SAME (dedupe_file_range) on a
 file opened ro
Message-ID: <20160717223227.GA3212@angband.pl>
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

This is a resend of a patch I've targetted at the wrong maintainer (btrfs
guys rather than Al Viro/vfs).  Since then, I've tested it on xfs-devel
(f0b34b677df10d9e3deffcd0b1c1aaaaf0234b80 atop of 4.7-rc5 and -rc7).

Review so far:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/56563

An idea to relax the check and allow dedupe to everyone who can read the
file was shot down because of concerns that in some edge cases it might be
possible to clobber a targetted file.  Thus, we're back to the original
patch, requiring ro descriptor but rw permission.


Meow!
-- 
An imaginary friend squared is a real enemy.
