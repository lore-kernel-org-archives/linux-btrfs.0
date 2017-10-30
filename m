Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43772 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbdJ3M5I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 08:57:08 -0400
Date: Mon, 30 Oct 2017 13:55:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com,
        mathieu.desnoyers@efficios.com
Subject: Re: [PATCH 2/3] btrfs: Remove redundant memory barrier
Message-ID: <20171030125517.GR3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1508512259-16867-1-git-send-email-nborisov@suse.com>
 <1508512259-16867-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1508512259-16867-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 20, 2017 at 06:10:58PM +0300, Nikolay Borisov wrote:
> As per atomic_t.txt documentation :
>  - RMW operations that have a return value are fully ordered;
> 
> atomic_xchg is one such operation so it already includes everything it needs
> w.r.t memory ordering and add a comment ot be more explicit about that.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
