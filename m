Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49027 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753484AbdIFM4v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 08:56:51 -0400
Date: Wed, 6 Sep 2017 14:55:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: move finish_wait out of the loop
Message-ID: <20170906125522.GK31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170901221430.10131-3-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170901221430.10131-3-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 01, 2017 at 04:14:28PM -0600, Liu Bo wrote:
> If we're still going to wait after schedule(), we don't have to do
> finish_wait() to remove our %wait_queue_entry since prepare_to_wait()
> won't add the same %wait_queue_entry twice.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
