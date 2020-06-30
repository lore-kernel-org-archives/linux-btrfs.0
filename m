Return-Path: <SRS0=P7ik=AL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FA2C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jun 2020 14:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7764E2072D
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jun 2020 14:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731346AbgF3OgP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 10:36:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:54920 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbgF3OgP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jun 2020 10:36:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D1E46B613;
        Tue, 30 Jun 2020 14:36:13 +0000 (UTC)
Date:   Tue, 30 Jun 2020 09:36:11 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 2/8] btrfs: Move FS error state bit early during write
Message-ID: <20200630143611.26v5chluocc2mmrk@fiona>
References: <20200622162017.21773-1-rgoldwyn@suse.de>
 <20200622162017.21773-3-rgoldwyn@suse.de>
 <20200630082248.GR27795@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630082248.GR27795@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 10:22 30/06, David Sterba wrote:
> On Mon, Jun 22, 2020 at 11:20:11AM -0500, Goldwyn Rodrigues wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > We don't need the inode locked to check for the error bit. Move the
> > check early.
> 
> This lacks explanation why it's not needed. I've checked history of the
> code and it seems the error state flags has been after all other checks
> since long, starting in acce952b0263825d. But it's part of a bigger
> patch and is not specific about this call site.
> 
> If something checks state and changes the location, we need to make sure
> the state is not affected by code between the old and new location.

This is a filesystem state bit as opposed to a file level state bit. The
bit states that you don't let writes proceed because of a filesystem
error. Why would you need a inode level lock for that? It is better to
return -EROFS early enough rather than take a lock, check for filesystem
failure, release the lock and then return an error.

The other check is in start_transaction, which perhaps is for
writes-in-flight.

-- 
Goldwyn
