Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50852 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750736AbdAXK7p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 05:59:45 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7A4C9AD97
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 10:59:43 +0000 (UTC)
Date: Tue, 24 Jan 2017 11:59:26 +0100
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: quota: fix printing during wait mode
Message-ID: <20170124105926.GS11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1484704600-16079-1-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1484704600-16079-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 17, 2017 at 08:56:39PM -0500, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> If we call "btrfs quota rescan -w", it will attempt to start the rescan
> operation, wait for it, and then print the "quota rescan started" message.
> The wait could last an arbitrary amount of time, so printing it after
> the wait isn't very helpful.
> 
> This patch reworks how we print the rescan started message as well as the
> printing of the messages, including adding an error message for status
> query failures (which could be EPERM/EFAULT/ENOMEM, not just no rescan
> in progress) and wait failures.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Applied, thanks.

I need to think about the 2nd patch, the command line option naming. The
semantics is clear.
