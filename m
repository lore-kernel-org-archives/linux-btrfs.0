Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754609AbdGJQwz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 12:52:55 -0400
Date: Mon, 10 Jul 2017 18:51:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.com>
Cc: jeffm@suse.com, linux-btrfs@vger.kernel.org, lufq.fnst@cn.fujitsu.com
Subject: Re: [PATCH v2 06/13] btrfs: btrfs_check_shared should manage its own
 transaction
Message-ID: <20170710165141.GN2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170629035705.1589-1-enadolski@suse.com>
 <20170629035705.1589-7-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170629035705.1589-7-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 28, 2017 at 09:56:58PM -0600, Edmund Nadolski wrote:
> Commit afce772e87c3 ("btrfs: fix check_shared for fiemap ioctl") added
> transaction semantics around calls to btrfs_check_shared() in order to
> provide accurate accounting of delayed refs. The transaction management
> should be done inside btrfs_check_shared(), so that callers do not need
> to manage transactions individually.
> 
> Signed-off-by: Edmund Nadolski <enadolski@suse.com>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
