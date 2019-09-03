Return-Path: <SRS0=cRuQ=W6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4126C3A5A5
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Sep 2019 06:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1BA72168B
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Sep 2019 06:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfICGVE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 02:21:04 -0400
Received: from verein.lst.de ([213.95.11.211]:55483 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbfICGVE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Sep 2019 02:21:04 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 106EB227A8A; Tue,  3 Sep 2019 08:21:01 +0200 (CEST)
Date:   Tue, 3 Sep 2019 08:21:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        darrick.wong@oracle.com, david@fromorbit.com, riteshh@linux.ibm.com
Subject: Re: [PATCH v3 0/15] Btrfs iomap
Message-ID: <20190903062100.GA16612@lst.de>
References: <20190901200836.14959-1-rgoldwyn@suse.de> <20190902164331.GE6263@lst.de> <4d039e8e-dc35-8092-4ee0-4a2e0f43f233@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d039e8e-dc35-8092-4ee0-4a2e0f43f233@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 03, 2019 at 11:51:24AM +0800, Shiyang Ruan wrote:
> The XFS part of dax CoW support has been implementing recently.  Please 
> review this[1] if necessary.  It's based on this iomap patchset(the 1st 
> version), and uses the new srcmap.
>
> [1]: https://lkml.org/lkml/2019/7/31/449

For the initial stage I'm not interested in DAX reflink support yet
(although that is also very interesting), just to make sure the
two iomap support is also used by the buffer write path for XFS,
removing the current hack where iomap_begin reports the data fork
mapping only and relies in ->writepage to handle that case.
