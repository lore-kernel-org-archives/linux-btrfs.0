Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46218 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbdG0KJr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 06:09:47 -0400
Date: Thu, 27 Jul 2017 03:09:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthias Kaehlcke <mka@chromium.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH] btrfs: Remove extra parentheses from condition in
 copy_items()
Message-ID: <20170727100945.GA5221@infradead.org>
References: <20170726204759.160649-1-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170726204759.160649-1-mka@chromium.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -		if ((i == (nr - 1)))
> +		if (i == (nr - 1))

Please remove the other set of redundant parentheses as well if you
change that line.
