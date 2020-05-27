Return-Path: <SRS0=8zrQ=7J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5464C433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 May 2020 13:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF57A208FE
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 May 2020 13:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387627AbgE0NMg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 May 2020 09:12:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:37210 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387581AbgE0NMf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 May 2020 09:12:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 529DCAEE2;
        Wed, 27 May 2020 13:12:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8D7D2DA72D; Wed, 27 May 2020 15:11:35 +0200 (CEST)
Date:   Wed, 27 May 2020 15:11:35 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Johannes Thumshirn <jth@kernel.org>,
        David Sterba <dsterba@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Richard Weinberger <richard@nod.at>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH v3 0/3] Add file-system authentication to BTRFS
Message-ID: <20200527131135.GD18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Johannes Thumshirn <jth@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Richard Weinberger <richard@nod.at>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20200514092415.5389-1-jth@kernel.org>
 <5663c6ca-87d4-8a98-3338-e9a077f4c82f@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5663c6ca-87d4-8a98-3338-e9a077f4c82f@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, May 27, 2020 at 10:08:06AM +0800, Qu Wenruo wrote:
> > Changes since v2:
> > - Select CONFIG_CRYPTO_HMAC and CONFIG_KEYS (kbuild robot)
> > - Fix double free in error path
> > - Fix memory leak in error path
> > - Disallow nodatasum and nodatacow when authetication is use (Eric)
> 
> Since we're disabling NODATACOW usages, can we also disable the
> following features?
> - v1 space cache
>   V1 space cache uses NODATACOW file to store space cache, althouhg it
>   has inline csum, but it's fixed to crc32c. So attacker can easily
>   utilize this hole to mess space cache, and do some DoS attack.
> 
> - fallocate
>   I'm not 100% sure about this, but since nodatacow is already a second
>   class citizen in btrfs, maybe not supporting fallocate is not a
>   strange move.

- swapfile
  NODATACOW is required for swapfile, so authentication and swapfile are
  mutualy exclusive.
