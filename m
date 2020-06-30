Return-Path: <SRS0=P7ik=AL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31010C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jun 2020 16:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B19520723
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jun 2020 16:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389019AbgF3Qfo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 12:35:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:34078 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726639AbgF3Qfo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jun 2020 12:35:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0D718ADFE;
        Tue, 30 Jun 2020 16:35:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 73528DA790; Tue, 30 Jun 2020 18:35:27 +0200 (CEST)
Date:   Tue, 30 Jun 2020 18:35:27 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, dsterba@suse.cz, david@fromorbit.com,
        darrick.wong@oracle.com, hch@lst.de,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 1/6] iomap: Convert wait_for_completion to flags
Message-ID: <20200630163527.GZ27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, david@fromorbit.com, darrick.wong@oracle.com,
        hch@lst.de, Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20200629192353.20841-1-rgoldwyn@suse.de>
 <20200629192353.20841-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629192353.20841-2-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jun 29, 2020 at 02:23:48PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Convert wait_for_completion boolean to flags so we can pass more flags
> to iomap_dio_rw()
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/ext4/file.c        | 11 +++++++++--
>  fs/gfs2/file.c        | 14 ++++++++++----
>  fs/iomap/direct-io.c  |  3 ++-
>  fs/xfs/xfs_file.c     | 15 +++++++++++----
>  fs/zonefs/super.c     | 16 ++++++++++++----
>  include/linux/iomap.h | 11 ++++++++++-

Though it's an API change I think you should CC all involved subsystems'
mailinglists too.  I don't see GFS2 or zonefs.
