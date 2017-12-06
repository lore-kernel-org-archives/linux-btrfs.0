Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49782 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751453AbdLFOWn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Dec 2017 09:22:43 -0500
Date: Wed, 6 Dec 2017 15:20:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: disable FUA if mounted with nobarrier
Message-ID: <20171206142043.GZ3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <bf59f09eff9232dcb5872aab4c975a776232b6ac.1512543205.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bf59f09eff9232dcb5872aab4c975a776232b6ac.1512543205.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 05, 2017 at 10:54:02PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> I was seeing disk flushes still happening when I mounted a Btrfs
> filesystem with nobarrier for testing. This is because we use FUA to
> write out the first super block, and on devices without FUA support, the
> block layer translates FUA to a flush. Even on devices supporting true
> FUA, using FUA when we asked for no barriers is surprising.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

The documented nobarrier behaviour matches the updated code.
