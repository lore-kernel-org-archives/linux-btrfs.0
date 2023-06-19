Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849E0EB64D9
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Jun 2023 15:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbjFSPpN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Jun 2023 11:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbjFSPpG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Jun 2023 11:45:06 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A1A139;
        Mon, 19 Jun 2023 08:45:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9D1CC1F38D;
        Mon, 19 Jun 2023 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1687189500;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yLSpnZMq1VP6bVEp1wTg9KcwJ0gQP+VEqdtcmClSXfw=;
        b=KpXi6LHmQhkuY+y/Q6sAF2+7b+oL/9RNZfRM/CyubI9zWwG/Tn2pcpQVXmK+FdDM0+0dAX
        CwmtJZYZNI+abcPZMVW6gpg6hKvI3ZTvPzL5U2NYHikN8Q6DhSigGhAXumMLT3jaOsxse8
        ekGDLUX8unKlXwSzAg8Y6/e4JOLolgg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1687189500;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yLSpnZMq1VP6bVEp1wTg9KcwJ0gQP+VEqdtcmClSXfw=;
        b=OuBoqUC+lphZI6avYQnWdhfwi2Ejqtf7QUh/g+NDloaaLyu4xG63SLonT5F/9jcnNNSkY5
        6nw+y2DQVmbOl0Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 78125139C2;
        Mon, 19 Jun 2023 15:45:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pMUfHPx3kGR1RwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 19 Jun 2023 15:45:00 +0000
Date:   Mon, 19 Jun 2023 17:38:37 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: update i_version in update_dev_time
Message-ID: <20230619153837.GB16168@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20230615124946.106957-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615124946.106957-1-jlayton@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jun 15, 2023 at 08:49:45AM -0400, Jeff Layton wrote:
> When updating the ctime, we also want to update i_version.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> This is just something I noticed by inspection. There is probably no way
> to test this today unless you can somehow get to this inode via nfsd.
> Still, I think it's the right thing to do for consistency's sake.

I don't see anything wrong with setting the iversion bit, however I also
don't see where this would be useful. Agreed with the consistency,
otherwise the time is updated when device super block is wiped or a
device initialized, both are big events so missing that due to lack of
iversion update seems unlikely. I'll add it to the queue, thanks.
