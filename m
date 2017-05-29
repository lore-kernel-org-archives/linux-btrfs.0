Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51761 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750966AbdE2NNP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 09:13:15 -0400
Date: Mon, 29 May 2017 15:12:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/13] fs: remove the unused error argument to
 dio_end_io()
Message-ID: <20170529131213.GA14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170526085620.3113-1-hch@lst.de>
 <20170526085620.3113-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170526085620.3113-6-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 26, 2017 at 11:56:12AM +0300, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>

For the btrfs bits

Acked-by: David Sterba <dsterba@suse.com>
