Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50048 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758443AbdJQSSC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 14:18:02 -0400
Date: Tue, 17 Oct 2017 20:16:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND] btrfs-progs: allow "no" to disable compression
 for convenience
Message-ID: <20171017181615.GD3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <87po9p7uu9.wl-satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87po9p7uu9.wl-satoru.takeuchi@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 14, 2017 at 09:54:54PM +0900, Satoru Takeuchi wrote:
> It's messy to use "" to disable compression. Introduce the new value "no"
> which can also be used for this purpose.
> 
> Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>

Applied, thanks.
