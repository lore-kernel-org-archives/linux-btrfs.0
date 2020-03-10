Return-Path: <SRS0=1T4y=43=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFD7C18E5B
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Mar 2020 16:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3ACF9215A4
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Mar 2020 16:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgCJQii (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:38:38 -0400
Received: from verein.lst.de ([213.95.11.211]:53926 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgCJQii (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Mar 2020 12:38:38 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8A67B68BEB; Tue, 10 Mar 2020 17:38:35 +0100 (CET)
Date:   Tue, 10 Mar 2020 17:38:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/15] btrfs: get rid of one layer of bios in direct I/O
Message-ID: <20200310163835.GD6361@lst.de>
References: <cover.1583789410.git.osandov@fb.com> <f9d0f9e8b8d11ff103654387f4370f50c6c074ae.1583789410.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9d0f9e8b8d11ff103654387f4370f50c6c074ae.1583789410.git.osandov@fb.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 09, 2020 at 02:32:38PM -0700, Omar Sandoval wrote:
> 1. The bio created by the generic direct I/O code (dio_bio).
> 2. A clone of dio_bio we create in btrfs_submit_direct() to represent
>    the entire direct I/O range (orig_bio).
> 3. A partial clone of orig_bio limited to the size of a RAID stripe that
>    we create in btrfs_submit_direct_hook().
> 4. Clones of each of those split bios for each RAID stripe that we
>    create in btrfs_map_bio().

Just curious:  what is number 3 useful for?
