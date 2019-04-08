Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F021FC10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 13:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0DD8213F2
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 13:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfDHNKP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 09:10:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:49526 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbfDHNKP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 09:10:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9D3E5AE54;
        Mon,  8 Apr 2019 13:10:14 +0000 (UTC)
Date:   Mon, 8 Apr 2019 15:10:11 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Leonid Bloch <lbloch@janustech.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
Subject: Re: Cryptographically verifying a btrfs subvolume
Message-ID: <20190408131010.GA19386@linux-x5ow.site>
References: <adac7db8-aed6-9573-ec09-4acd5059801e@janustech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <adac7db8-aed6-9573-ec09-4acd5059801e@janustech.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 08, 2019 at 11:27:51AM +0000, Leonid Bloch wrote:
> Hi List,
> 
> Can you suggest a way of cryptographically verifying the content of a 
> btrfs subvolume, besides the naïve approach, of running a cryptographic 
> hash function on the output of btrfs send?
> 
> Back in 2014, an RFC patch was sent to allow using sha256 instead of 
> crc32c for checksumming.
> (https://patchwork.kernel.org/patch/5363311)
> It was not merged. Had it been merged, one could just check the return 
> value of btrfs scrub, instead of checksumming the whole btrfs send 
> output, correct?

Hi Leonid,

I'm working on this feature currently but unfortunately get distracted with
other things all too often.

Thanks for your patience.

Byte,
	Johannes
-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
