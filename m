Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41913 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752543AbdLLR2B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 12:28:01 -0500
Date: Tue, 12 Dec 2017 18:25:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Pravin Shedge <pravin.shedge4linux@gmail.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/45] fs: btrfs: remove duplicate includes
Message-ID: <20171212172557.GL3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1512578671-4988-1-git-send-email-pravin.shedge4linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1512578671-4988-1-git-send-email-pravin.shedge4linux@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 06, 2017 at 10:14:31PM +0530, Pravin Shedge wrote:
> These duplicate includes have been found with scripts/checkincludes.pl but
> they have been removed manually to avoid removing false positives.
> 
> Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>

Added to queue, thanks.
