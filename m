Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11326C4332F
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Apr 2022 21:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346388AbiDEVNn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 17:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453353AbiDEP4Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2022 11:56:25 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBE013369F;
        Tue,  5 Apr 2022 08:00:29 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 733E41F38D;
        Tue,  5 Apr 2022 15:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649170828;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ymtPDihI+BaQ3NeOugErm/4eh+I6Mm9oHF+riZmHBLg=;
        b=PYffe1B2SylsYUV0f9qe2/bAy8aZZyiPuclBV3eRel5+cDDU7gQ4IZotyPmAHFDgtZh4nf
        CEAqRcEKqEe25Ynll2UkCgJiksZqNgGBXLsEKC99aD8eJ2+SpchirAoKMF1SahAWB2X5dT
        b+C0z/G/dTpjfqXks56IrGx5FZVuOuw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649170828;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ymtPDihI+BaQ3NeOugErm/4eh+I6Mm9oHF+riZmHBLg=;
        b=CbqLhoUf0auHaeiPtEl8aWUXBYSpB+lJrYlOpNvACf3SkrSLfAsA7qL98zQD88xciPBzv7
        LVXjD3jz52EK63CQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 37D47A3B97;
        Tue,  5 Apr 2022 15:00:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0C30DDA80E; Tue,  5 Apr 2022 16:56:26 +0200 (CEST)
Date:   Tue, 5 Apr 2022 16:56:26 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: cleanup btrfs bio handling, part 1
Message-ID: <20220405145626.GY15609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        Qu Wenruo <wqu@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20220404044528.71167-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404044528.71167-1-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 04, 2022 at 06:45:16AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series  moves btrfs to use the new as of 5.18 bio interface and
> cleans up a few close by areas.  Larger cleanups focussed around
> the btrfs_bio will follow as a next step.

I've looked at the previous batch of 40 patches which was doing some
things I did not like (eg. removing the worker) but this subset are just
cleanups and all seem to be fine. I'll add the series as topic branch to
for-next and move misc-next. Thanks.
