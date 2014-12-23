Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38810 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbaLWKfO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 05:35:14 -0500
Date: Tue, 23 Dec 2014 02:35:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kmo@daterainc.com>, Ming Lin <mlin@minggr.net>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 06/17] btrfs: make use of immutable biovecs
Message-ID: <20141223103513.GA27600@infradead.org>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <83a9ee8a309f8e08490c5dd715a608ea054f5c33.1419241597.git.dongsu.park@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <83a9ee8a309f8e08490c5dd715a608ea054f5c33.1419241597.git.dongsu.park@profitbricks.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This seems like it could be applied without the rest of the series,
right?  Might be worth to get it into the btrfs tree ASAP?

