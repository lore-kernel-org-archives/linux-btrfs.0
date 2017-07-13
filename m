Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49001 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750755AbdGMAT1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 20:19:27 -0400
Date: Thu, 13 Jul 2017 02:18:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.com>
Cc: dsterba@suse.cz, jeffm@suse.com, linux-btrfs@vger.kernel.org,
        lufq.fnst@cn.fujitsu.com
Subject: Re: [PATCH v3 10/13] btrfs: backref, add tracepoints for prelim_ref
 insertion and merging
Message-ID: <20170713001813.GZ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170712222011.26705-1-enadolski@suse.com>
 <20170712222011.26705-4-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170712222011.26705-4-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 04:20:08PM -0600, Edmund Nadolski wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> This patch adds a tracepoint event for prelim_ref insertion and
> merging.  For each, the ref being inserted or merged and the count
> of tree nodes is issued.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I've chanbed "key=[%llu %u %llu]" -> "key=[%llu,%u,%llu]" and updated
the wiki.
