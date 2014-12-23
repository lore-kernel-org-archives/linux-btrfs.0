Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:40762 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbaLWMJK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 07:09:10 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so10646605wib.10
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Dec 2014 04:09:08 -0800 (PST)
Date: Tue, 23 Dec 2014 13:09:03 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kmo@daterainc.com>, Ming Lin <mlin@minggr.net>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 06/17] btrfs: make use of immutable biovecs
Message-ID: <20141223120903.GD15080@gmail.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <83a9ee8a309f8e08490c5dd715a608ea054f5c33.1419241597.git.dongsu.park@profitbricks.com>
 <20141223103513.GA27600@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20141223103513.GA27600@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23.12.2014 02:35, Christoph Hellwig wrote:
> This seems like it could be applied without the rest of the series,
> right?  Might be worth to get it into the btrfs tree ASAP?

Ah, you're right.
While patch #5 must be in this series, patch #6 does not necessarily
have to be included. This conversion should belong to the multipage
bvecs series. So I'll skip #6 in the next round.

Thanks,
Dongsu
