Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40629 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754131AbdHWPvo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 11:51:44 -0400
Date: Wed, 23 Aug 2017 17:50:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, clm@fb.com
Subject: Re: [PATCH 1/7] Btrfs: fix blk_status_t/errno confusion
Message-ID: <20170823155019.GD2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1503470354.git.osandov@fb.com>
 <f67c635fab2edc4212f0a30cdb0dfe709f1583f0.1503470354.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f67c635fab2edc4212f0a30cdb0dfe709f1583f0.1503470354.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 22, 2017 at 11:45:59PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> This fixes several instances of blk_status_t and bare errno ints being
> mixed up, some of which are real bugs.

Reviewed-by: David Sterba <dsterba@suse.com>

The real bugs are lurking in the error cases, other than BLK_STS_OK that
is equivalent to the old return values.

Seems like blk_status_t conversion of raid56.c has been entirely
skipped, and maybe some of the changes brought by the btrfs pull. Thanks
for catching it. I'll prepare a pull request with this one for 4.13-rc7.
The other patch 2/7 is not that urgent and can wait.
