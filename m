Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF34C77B75
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 May 2023 11:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbjEWLjL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 May 2023 07:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbjEWLjK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2023 07:39:10 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E269A118
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2023 04:39:09 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3E4C36732D; Tue, 23 May 2023 13:39:07 +0200 (CEST)
Date:   Tue, 23 May 2023 13:39:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/16] btrfs: factor out a btrfs_verify_page helper
Message-ID: <20230523113907.GB28908@lst.de>
References: <20230523081322.331337-1-hch@lst.de> <20230523081322.331337-3-hch@lst.de> <7d1d512a-e4d6-70c1-93c9-61800955b4b0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d1d512a-e4d6-70c1-93c9-61800955b4b0@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 23, 2023 at 06:16:25PM +0800, Anand Jain wrote:
>>   +static int btrfs_verify_page(struct page *page, u64 start)
>
>  Did you consider making it an inline function?

No, why?
