Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38206 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750981AbdE1J13 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 May 2017 05:27:29 -0400
Date: Sun, 28 May 2017 02:27:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk,
        linux-api@vger.kernel.org, adam.manzanares@wdc.com,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 0/10 v9] No wait AIO
Message-ID: <20170528092728.GA14519@infradead.org>
References: <20170524164150.9492-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170524164150.9492-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>  Changes since v8:
>  + Err out AIO reads with -EINVAL flagged as RWF_NOWAIT

Ugg, why?  Reads aren't really treated any different than writes in
the direct I/O code.
