Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbcCaQla (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 12:41:30 -0400
Date: Thu, 31 Mar 2016 18:40:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: clm@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [RESEND][PATCH] btrfs: Add qgroup tracing
Message-ID: <20160331164054.GG6230@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160330001955.GH15881@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160330001955.GH15881@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 29, 2016 at 05:19:55PM -0700, Mark Fasheh wrote:
> This patch adds tracepoints to the qgroup code on both the reporting side
> (insert_dirty_extents) and the accounting side. Taken together it allows us
> to see what qgroup operations have happened, and what their result was.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

Reviewed-by: David Sterba <dsterba@suse.com>
