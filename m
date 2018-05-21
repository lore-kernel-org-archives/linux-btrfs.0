Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:53578 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752398AbeEUOUx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 10:20:53 -0400
Received: by mail-it0-f54.google.com with SMTP id n64-v6so21223923itb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 07:20:53 -0700 (PDT)
Subject: Re: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
To: Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, hch@infradead.org, colyli@suse.de,
        snitzer@redhat.com, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com,
        linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org,
        neilb@suse.com
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <dd30e115-f1c7-aa13-bb82-bffece8d07d7@kernel.dk>
Date: Mon, 21 May 2018 08:20:50 -0600
MIME-Version: 1.0
In-Reply-To: <20180520222558.7053-1-kent.overstreet@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/20/18 4:25 PM, Kent Overstreet wrote:
> Jens - this series does the rest of the conversions that Christoph wanted, and
> drops bioset_create().
> 
> Only lightly tested, but the changes are pretty mechanical. Based on your
> for-next tree.

Looks good to me. I'll let it simmer for a bit to give folks a chance
to comment on it.

-- 
Jens Axboe

