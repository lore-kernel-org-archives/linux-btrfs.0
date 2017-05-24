Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:7924 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdEXPuU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 11:50:20 -0400
From: Bart Van Assche <Bart.VanAssche@sandisk.com>
To: "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
CC: "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 01/15] nvme-lightnvm: use blk_execute_rq in
 nvme_nvm_submit_user_cmd
Date: Wed, 24 May 2017 15:50:18 +0000
Message-ID: <1495641016.2823.6.camel@sandisk.com>
References: <20170518131812.22956-1-hch@lst.de>
         <20170518131812.22956-2-hch@lst.de>
In-Reply-To: <20170518131812.22956-2-hch@lst.de>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2017-05-18 at 15:17 +0200, Christoph Hellwig wrote:
> Instead of reinventing it poorly.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>