Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51133 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751154AbdGMAxH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 20:53:07 -0400
Date: Thu, 13 Jul 2017 02:51:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.com>
Cc: dsterba@suse.cz, jeffm@suse.com, linux-btrfs@vger.kernel.org,
        lufq.fnst@cn.fujitsu.com
Subject: Re: [PATCH v3 09/13] btrfs: add a node counter to each of the rbtrees
Message-ID: <20170713005152.GB2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170712222011.26705-1-enadolski@suse.com>
 <20170712222011.26705-3-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170712222011.26705-3-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 04:20:07PM -0600, Edmund Nadolski wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> This patch adds counters to each of the rbtrees so that we can tell
> how large they are growing for a given workload.  These counters
> will be exported by tracepoints in the next patch.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
