Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbbH1Rje (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 13:39:34 -0400
Date: Fri, 28 Aug 2015 19:38:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: trimming some start_transaction() code away
Message-ID: <20150828173856.GM11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150827235345.GA1373@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150827235345.GA1373@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 27, 2015 at 11:53:45PM +0000, Alexandru Moise wrote:
> Just call kmem_cache_zalloc() instead of calling kmem_cache_alloc().
> We're just initializing most fields to 0, false and NULL later on
> _anyway_, so to make the code mode readable and potentially gain
> a bit of performance (completely untested claim), we should fill our
> btrfs_trans_handle with zeros on allocation then just initialize
> those five remaining fields (not counting the list_heads) as normal.
> 
> Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>

The performance gain is arguable but the generated code should be
smaller, which counts.

Reviewed-by: David Sterba <dsterba@suse.com>
