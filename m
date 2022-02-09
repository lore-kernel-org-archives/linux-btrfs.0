Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C27C433F5
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Feb 2022 15:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbiBIP3I (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Feb 2022 10:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235815AbiBIP3H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Feb 2022 10:29:07 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127F3C0613CA
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Feb 2022 07:29:10 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 76FB2210F8;
        Wed,  9 Feb 2022 15:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1644420549;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I3KdtakF4UpDol6lFvkkNKJN12BSzdUvWp2YCanZLBQ=;
        b=I30SxeCR/V16B0lVQx4uEHK0sRFk4IBDbqTUKEKCMv8usnG09QNTX6GvkxW1fnBaGC5nbU
        Xg5O4UUvJV0Ov0gvtYeEXYCPHxcYW0ZX/lvbwHQ3LKObK2mEZuHmvUa+H+/HzKWY3dMEhv
        HYNjoI0+kTBhBlTQ9PtwE/TB0eXV7bA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1644420549;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I3KdtakF4UpDol6lFvkkNKJN12BSzdUvWp2YCanZLBQ=;
        b=pFy3xIyfwWiNCbw8rjnIv/hYWSujQl35KlphbK8O/ygWzmGRkmmMBXw0Ju6OxG6ElDfkbZ
        Cx8+xcKi+dzDjYDQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 6F049A3B92;
        Wed,  9 Feb 2022 15:29:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 93734DA989; Wed,  9 Feb 2022 16:25:28 +0100 (CET)
Date:   Wed, 9 Feb 2022 16:25:28 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs-progs: sanity check global roots key.offset
Message-ID: <20220209152528.GL12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <a5b18eac38f561d7f671454b0601f5173b5cc2cd.1644348533.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5b18eac38f561d7f671454b0601f5173b5cc2cd.1644348533.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 08, 2022 at 02:30:05PM -0500, Josef Bacik wrote:
> For !extent tree v2 we should validate the key.offset == 0, and for
> extent tree v2 we should validate that key.offset < nr_global_roots.  If
> this fails we need to fail to load the global root so that the
> appropriate action is taken.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
> Dave, this fixes GH issue https://github.com/kdave/btrfs-progs/issues/446, the
> problem was we weren't catching that nr_global_roots was incorrect and then
> segfaulting later.  I think I sent this as part of a series, but it stands
> alone.

Thanks, I think I've merged all the prep stuff, in kernel and in progs
too, so I'll do another batch for 5.17.
