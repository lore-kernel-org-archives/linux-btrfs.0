Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA1D8C10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 09:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9104D20675
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 09:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfDOJ3G (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 05:29:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:54312 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726718AbfDOJ3G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 05:29:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 274EDB00C;
        Mon, 15 Apr 2019 09:29:05 +0000 (UTC)
Date:   Mon, 15 Apr 2019 11:29:04 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2.1 1/3] btrfs: Remove "recovery" mount option
Message-ID: <20190415092904.GC7586@linux-x5ow.site>
References: <20190415053608.29003-1-wqu@suse.com>
 <20190415053608.29003-2-wqu@suse.com>
 <20190415090557.GB7586@linux-x5ow.site>
 <ae61b9b7-254d-0e58-9350-b822312e3f11@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae61b9b7-254d-0e58-9350-b822312e3f11@gmx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 15, 2019 at 05:08:55PM +0800, Qu Wenruo wrote:
> It is mentioned as deprecated in btrfs(5):
>        recovery
>            (since: 3.2, default: off, deprecated since: 4.5)
> 
>                Note
>                this option has been replaced by usebackuproot and should not
>                be used but will work on 4.5+ kernels.
> 
> 
> The removal date is not mentioned though.

Hmm ok, just because xfs for example give an schedule for removal of mount
options.

Either way, code wise it looks ok to me:

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
