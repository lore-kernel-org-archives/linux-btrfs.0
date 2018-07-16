Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53564 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727411AbeGPRRD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 13:17:03 -0400
Date: Mon, 16 Jul 2018 18:48:42 +0200
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?Q?St=E9phane?= Lesimple <stephane_btrfs@lesimple.fr>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs-progs: check: enhanced progress indicator
Message-ID: <20180716164842.GR3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530732014-5449-1-git-send-email-stephane_btrfs@lesimple.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1530732014-5449-1-git-send-email-stephane_btrfs@lesimple.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2018 at 09:20:12PM +0200, Stéphane Lesimple wrote:
> This patch replaces the current ".oOo."-style progress indicator of
> btrfs check (-p), by a more helpful live indication of the check progress.
> I've been using it on a custom btrfs-progs version since 2015.
> 
> Here's how the output looks like on a 22 Tb 5-disk RAID1 FS:
> 
> # btrfs check -p /dev/mapper/luks-ST10000VN0004-XXXXXXXX
> Opening filesystem to check...
> Checking filesystem on /dev/mapper/luks-ST10000VN0004-XXXXXXXX
> UUID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
> [1/7] checking extents           (0:20:21 elapsed, 950958 items checked)
> [2/7] checking root items        (0:01:29 elapsed, 15121 items checked)
> [3/7] checking free space cache  (0:00:11 elapsed, 4928 items checked)
> [4/7] checking fs roots          (0:51:31 elapsed, 600892 items checked)
> [5/7] checking csums             (0:14:35 elapsed, 754522 items checked)
> [6/7] checking root refs         (0:00:00 elapsed, 232 items checked)
> [7/7] checking quota groups skipped (not enabled on this FS)
> found 5286458060800 bytes used, no error found

Nice, this looks better than what we have now. Patches applied, with
some minor coding style adjustments and I changed the update period
back to 1 second, 50ms is IMHO too frequent for an operation that can
run for tens of minutes. Also as a safety against dumping too much
information to the log into if the output is redirected.
