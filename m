Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbcEBOwd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 10:52:33 -0400
Date: Mon, 2 May 2016 07:52:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-btrfs@vger.kernel.org,
        "open list:FILESYSTEMS (VFS and infrastructure)"
	<linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] block: avoid to call .bi_end_io() recursively
Message-ID: <20160502145232.GC20589@infradead.org>
References: <1461805743-3559-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461805743-3559-1-git-send-email-ming.lei@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 28, 2016 at 09:09:00AM +0800, Ming Lei wrote:
> The 3rd patch avoids to call .bi_end_io recursively in complete path.

Care to explain what the reason for doing that is?

If we have excessively long bi_end_io chains we should probably look
into fixing them instead.
