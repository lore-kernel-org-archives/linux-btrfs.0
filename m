Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50142 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758281AbdJQSS0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 14:18:26 -0400
Date: Tue, 17 Oct 2017 20:16:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND] btrfs-progs: allow "no" to disable compression
 for convenience
Message-ID: <20171017181639.GE3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <87po9p7uu9.wl-satoru.takeuchi@gmail.com>
 <ortddp$skc$1@blaine.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ortddp$skc$1@blaine.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 14, 2017 at 06:19:14PM +0200, Koen Kooi wrote:
> Op 14-10-17 om 14:54 schreef Satoru Takeuchi:
> > It's messy to use "" to disable compression. Introduce the new value "no"
> > which can also be used for this purpose.
> 
> Wouldn't 'none' be a better fit?

'none' will be also accepted
