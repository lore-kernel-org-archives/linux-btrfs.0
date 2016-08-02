Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37252 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934856AbcHBMdD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Aug 2016 08:33:03 -0400
Date: Tue, 2 Aug 2016 05:32:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Shaun Tancheff <shaun@tancheff.com>,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@fb.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Mike Christie <mchristi@redhat.com>
Subject: Re: Fixup direct bi_rw modifiers
Message-ID: <20160802123245.GA18679@infradead.org>
References: <1469915148-20452-1-git-send-email-shaun@tancheff.com>
 <20160801114713.GA16806@infradead.org>
 <36734f69-33f5-c2fd-67da-d2d867741403@kernel.dk>
 <a2fbb070-ad57-0015-45d0-2402368ba35e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a2fbb070-ad57-0015-45d0-2402368ba35e@kernel.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 01, 2016 at 01:55:36PM -0600, Jens Axboe wrote:
> 
> Set of three patches, where the target one is an actual bug fix...
> Temporary branch, I'll rebase it once -rc1 is out, if more
> changes/fixups need to be made in the next week until that happens.
> 
> http://git.kernel.dk/cgit/linux-block/log/?h=for-4.8/bi_rwf

Thanks.  Any chance to have a slightly better name for the field?
E.g. bi_opf or bi_op_flags if we want to be a bit more verbose.
