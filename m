Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 306C4C433F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Mar 2022 14:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344855AbiC3OP1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 10:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346654AbiC3OP0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Mar 2022 10:15:26 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4790629B7D5
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Mar 2022 07:13:41 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id EDF3F210F4;
        Wed, 30 Mar 2022 14:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648649619;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bsYtAl1xDTg/oLTSWjimUHJyy2K0S0wKSZfQTXOvZ48=;
        b=avDJmaQEmHN7VfZmN2ncwo8oVaH25mazJY8YY54SnDDPJUHEVIphbBsUGLkWwZXCpiCs2c
        f+KI4PLy/yGsY0qhwiYUHZo0zwLyqRcMj1EYmQnGeI5s5/sjL8UtJPEkR5NhABMyCRZPO8
        J+Rfrq0Is8eI7Aepw1O9ci+APdKO/wQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648649619;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bsYtAl1xDTg/oLTSWjimUHJyy2K0S0wKSZfQTXOvZ48=;
        b=3OtJxFDEO8m4eppEskT0ynbF+h29svwERmedorb+BPBxVJ++gtVKJQEBfjbMwCANcA1bAp
        iCJgyR2l6qJM5BCA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id E370CA3B96;
        Wed, 30 Mar 2022 14:13:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 00CD8DA7F3; Wed, 30 Mar 2022 16:09:41 +0200 (CEST)
Date:   Wed, 30 Mar 2022 16:09:41 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Remove balance v1 ioctl
Message-ID: <20220330140941.GD2237@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20220330091407.1319454-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330091407.1319454-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 30, 2022 at 12:14:04PM +0300, Nikolay Borisov wrote:
> It was slated for removal in 5.18. So here are the patches which remove the
> relevant bits (patch 1 and 2). As a result of this simplification code can be
> juggled around a bit so further simplify btrfs_ioctl_balance(patch 3).
> 
> Nikolay Borisov (3):
>   btrfs: remove balance v1 ioctl
>   btrfs: remove checks for arg argument in btrfs_ioctl_balance
>   btrfs: simplify codeflow in btrfs_ioctl_balance

Added to misc-next, thanks. The first patch will go to 5.18 queue so we
adhere to the scheduled removal.
