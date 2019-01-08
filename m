Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90478C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 16:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A0032087F
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 16:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfAHQOn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 11:14:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:42392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728211AbfAHQOm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 11:14:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C9C72AE65;
        Tue,  8 Jan 2019 16:14:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 19F63DA7E8; Tue,  8 Jan 2019 17:14:09 +0100 (CET)
Date:   Tue, 8 Jan 2019 17:14:09 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix deadlock when using free space tree due to
 block group creation
Message-ID: <20190108161409.GL23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190108114441.5573-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108114441.5573-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 08, 2019 at 11:44:41AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When modifying the free space tree we can end up COWing one of its extent
> buffers which in turn might result in allocating a new chunk, which in
> turn can result in flushing (finish creation) of pending block groups. If
> that happens we can deadlock because creating a pending block group needs
> to update the free space tree, and if any of the updates tries to modify
> the same extent buffer that we are COWing, we end up in a deadlock since
> we try to write lock twice the same extent buffer.
> 
> So fix this by skipping pending block group creation if we are COWing an
> extent buffer from the free space tree. This is a case missed by commit
> 5ce555578e091 ("Btrfs: fix deadlock when writing out free space caches").
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202173
> Fixes: 5ce555578e091 ("Btrfs: fix deadlock when writing out free space caches
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Lighweight Reviewed-by, as the bug is in 4.19.x I'm going to push the
fix to 5.0. Thanks.
