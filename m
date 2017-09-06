Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54417 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753237AbdIFNvf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 09:51:35 -0400
Date: Wed, 6 Sep 2017 15:50:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: protect conditions within root->log_mutex while
 waiting
Message-ID: <20170906135006.GL31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170901221430.10131-5-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170901221430.10131-5-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 01, 2017 at 04:14:30PM -0600, Liu Bo wrote:
> Both wait_for_commit() and wait_for_writer() are checking the
> condition out of the mutex lock.
> 
> This refactors code a bit to be lock safe.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
