Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35928 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752464AbdFNM1n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Jun 2017 08:27:43 -0400
Date: Wed, 14 Jun 2017 14:26:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: test for device flush-able should be after wait
 code
Message-ID: <20170614122637.GA25451@suse.cz>
Reply-To: dsterba@suse.cz
References: <1497434558-715-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1497434558-715-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 14, 2017 at 06:02:38PM +0800, Anand Jain wrote:
> write_dev_flush() checks if the device is flush capable, however as
> the device mode can change any time, this check should be after the
> wait part of the code.

This would apply to code before "btrfs: wait part of the
write_dev_flush() can be separated out", right?

The problematic case is when a flush bio is sent, queue status changes
and waiting is skipped. A bio would leak. Next time the flushing is
enabled, write_dev_flush allocaes a new bio and either it would leak or
waiting will happen as expected.

The bio would leak only if the barriers are switched between write and
wait. Not impossible, but I still think a race hard to win. The
consequences are not absolutely fatal.

Also, the cleanups in write_dev_flush fix the bug in another way, so we
don't need this separate patch as a potential stable backport. The patch
mentioned above can be considered a fix but would need some manual
adaptations to apply. Therefore I don't think we need the $subj patch.
