Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6881EC10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 08:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4290520656
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 08:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfDOImD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 04:42:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:46948 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725828AbfDOImD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 04:42:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DC12AAEC8;
        Mon, 15 Apr 2019 08:42:01 +0000 (UTC)
Date:   Mon, 15 Apr 2019 10:42:01 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Christoph Anton Mitterer <calestyo@scientia.net>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: delayed_refs has NO entry / btrfs_update_root:136: Aborting
 unused transaction(No space left).
Message-ID: <20190415084200.GA7586@linux-x5ow.site>
References: <b2a668d7124f1d3e410367f587926f622b3f03a4.camel@scientia.net>
 <d35fa8de087c746f9affb789cf3ab599a3d042c1.camel@scientia.net>
 <9ff84820-5d7e-f541-6adc-29c4949d44e0@suse.de>
 <e92b879b03f4838cc05c1b80d20917d3be1ba7f7.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e92b879b03f4838cc05c1b80d20917d3be1ba7f7.camel@scientia.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Apr 13, 2019 at 12:46:28AM +0200, Christoph Anton Mitterer wrote:
> On Wed, 2019-03-20 at 10:59 +0100, Johannes Thumshirn wrote:
> > First of all, have you tried a more recent kernel than the Debian
> > kernels you referenced? E.g. Linus' current master or David's misc-
> > next
> > branch? Just so we don't try to hunt down a bug that's already fixed.
> 
> I haven't and that's a bit difficult for me unless it's packaged by the
> distro (policy reasons).
> 
> 
> Also giving out the image is a bit problematic as it's huge (8TB).
> 
> > Also if you can still reproduce the bug, please activate tracing in
> > btrfs and send the trace output.
> 
> How would I do that?
> 
> 
> In the meantime, I think I can reproduce it with fresh images so could
> you try the following:
> 
> # truncate --size 1G image
> # mkfs.btrfs image
> 
> # mount -o compress image /mnt
> # cd /mnt
> 
> # # create some data e.g.:
> # tar xaf /usr/src/linux-source-4.19.tar.xz
> # cd
> # umount /mnt
> 
> # losetup -r -f image
> # mount -o compress /dev/loop0 /mnt
> 
> # find /mnt -type f -exec filefrag -v {} \;
> 

I'll give it a try.


> 
> And there your kernel log will explode ;-)
> 
> The culprit seems to be the device itself being read-only i.e.
> losetup's -r, respectively blockdev --setro DEVICE which I've used
> previously.
> 
> If you repeat the above from the losetup point, but with -r ...
> everything works fine.
> Haven't checked whether -o compress actually makes a difference.
> 
> 
> Cheers,
> Chris.
> 
> 

-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
