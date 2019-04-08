Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107A8C10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 13:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC88D20663
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 13:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfDHNzp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 09:55:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:58090 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726383AbfDHNzp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 09:55:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2A6A7AFD1;
        Mon,  8 Apr 2019 13:55:44 +0000 (UTC)
Date:   Mon, 8 Apr 2019 15:55:43 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Leonid Bloch <lbloch@janustech.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
Subject: Re: Cryptographically verifying a btrfs subvolume
Message-ID: <20190408135543.GC19386@linux-x5ow.site>
References: <adac7db8-aed6-9573-ec09-4acd5059801e@janustech.com>
 <20190408131010.GA19386@linux-x5ow.site>
 <0c1d5ee2-7427-0ce1-046e-f8bf4ef878b4@janustech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0c1d5ee2-7427-0ce1-046e-f8bf4ef878b4@janustech.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 08, 2019 at 01:49:49PM +0000, Leonid Bloch wrote:
> Thanks for letting know! Btrfs inspect-internal csum-dump indeed sounds 
> awesome! Recursively, on a subvolume that would be perfect. Let me know 
> if help is needed.

Well actually the intention of this part was mostly to have a proper way of
verifying the checksums we write in the checksum tree.

I have a patchset in development that adds SHA-256 in the mix (it's actually
very similar to the patch you've referenced).

Apart from SHA-256 I want to have a not cryptographically secure checksum as
well which would help detecting duplicate extents and can be used for
de-duplication.

But this patchset is not anywhere near I can (or better want to) show to
someone.

Thanks for your patience.
	Johannes
-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
