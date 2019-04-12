Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C4CC10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 22:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F8AE20818
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 22:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfDLWqc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 18:46:32 -0400
Received: from mailgw-01.dd24.net ([193.46.215.41]:40672 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfDLWqc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 18:46:32 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-01.dd24.net (Postfix) with ESMTP id DBA785FEAB;
        Fri, 12 Apr 2019 22:46:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-01.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.35])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
        with ESMTP id qXBtz4FTlX7v; Fri, 12 Apr 2019 22:46:29 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-82-31.dynamic.mnet-online.de [82.135.82.31])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Fri, 12 Apr 2019 22:46:28 +0000 (UTC)
Message-ID: <e92b879b03f4838cc05c1b80d20917d3be1ba7f7.camel@scientia.net>
Subject: Re: delayed_refs has NO entry / btrfs_update_root:136: Aborting
 unused transaction(No space left).
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Sat, 13 Apr 2019 00:46:28 +0200
In-Reply-To: <9ff84820-5d7e-f541-6adc-29c4949d44e0@suse.de>
References: <b2a668d7124f1d3e410367f587926f622b3f03a4.camel@scientia.net>
         <d35fa8de087c746f9affb789cf3ab599a3d042c1.camel@scientia.net>
         <9ff84820-5d7e-f541-6adc-29c4949d44e0@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 2019-03-20 at 10:59 +0100, Johannes Thumshirn wrote:
> First of all, have you tried a more recent kernel than the Debian
> kernels you referenced? E.g. Linus' current master or David's misc-
> next
> branch? Just so we don't try to hunt down a bug that's already fixed.

I haven't and that's a bit difficult for me unless it's packaged by the
distro (policy reasons).


Also giving out the image is a bit problematic as it's huge (8TB).

> Also if you can still reproduce the bug, please activate tracing in
> btrfs and send the trace output.

How would I do that?


In the meantime, I think I can reproduce it with fresh images so could
you try the following:

# truncate --size 1G image
# mkfs.btrfs image

# mount -o compress image /mnt
# cd /mnt

# # create some data e.g.:
# tar xaf /usr/src/linux-source-4.19.tar.xz
# cd
# umount /mnt

# losetup -r -f image
# mount -o compress /dev/loop0 /mnt

# find /mnt -type f -exec filefrag -v {} \;


And there your kernel log will explode ;-)

The culprit seems to be the device itself being read-only i.e.
losetup's -r, respectively blockdev --setro DEVICE which I've used
previously.

If you repeat the above from the losetup point, but with -r ...
everything works fine.
Haven't checked whether -o compress actually makes a difference.


Cheers,
Chris.


