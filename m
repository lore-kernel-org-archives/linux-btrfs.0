Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56679 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3KXXeA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 18:34:00 -0500
Date: Sun, 24 Nov 2013 16:33:52 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>, Neil Brown <neilb@suse.de>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH] block: submit_bio_wait() conversions
Message-ID: <20131124233352.GG27594@kernel.dk>
References: <1385265810-16095-1-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1385265810-16095-1-git-send-email-kmo@daterainc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 23 2013, Kent Overstreet wrote:
> It was being open coded in a few places.

Thanks, applied (with Neils ack).

-- 
Jens Axboe

