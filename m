Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11451 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757295AbdEXQIN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 12:08:13 -0400
From: Bart Van Assche <Bart.VanAssche@sandisk.com>
To: "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
CC: "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 05/15] fs: remove the unused error argument to
 dio_end_io()
Date: Wed, 24 May 2017 16:08:09 +0000
Message-ID: <1495642088.2823.10.camel@sandisk.com>
References: <20170518131812.22956-1-hch@lst.de>
         <20170518131812.22956-6-hch@lst.de>
In-Reply-To: <20170518131812.22956-6-hch@lst.de>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2017-05-18 at 15:18 +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>