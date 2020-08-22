Return-Path: <SRS0=Elam=CA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63764C433DF
	for <linux-btrfs@archiver.kernel.org>; Sat, 22 Aug 2020 12:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48BCB207CD
	for <linux-btrfs@archiver.kernel.org>; Sat, 22 Aug 2020 12:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgHVMTC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 22 Aug 2020 08:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgHVMTB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Aug 2020 08:19:01 -0400
Received: from savella.carfax.org.uk (2001-ba8-1f1-f0e6-0-0-0-2.autov6rev.bitfolk.space [IPv6:2001:ba8:1f1:f0e6::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09526C061573
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Aug 2020 05:18:58 -0700 (PDT)
Received: from hrm by savella.carfax.org.uk with local (Exim 4.92)
        (envelope-from <hrm@savella.carfax.org.uk>)
        id 1k9SU5-0006fZ-NU; Sat, 22 Aug 2020 13:18:57 +0100
Date:   Sat, 22 Aug 2020 13:18:57 +0100
From:   Hugo Mills <hugo@carfax.org.uk>
To:     George Shuklin <george.shuklin@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Replacing or merging last snapshot
Message-ID: <20200822121857.GA1093@savella.carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        George Shuklin <george.shuklin@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <878539b1-b8eb-f547-fb4a-9026f1d51cf7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878539b1-b8eb-f547-fb4a-9026f1d51cf7@gmail.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Aug 22, 2020 at 02:48:18PM +0300, George Shuklin wrote:
> I wonder if there is a way to free space if there is only one snapshot
> available. The problem is that there is a hidden top-level (id=5) subvolume,
> and there was ever switch from top-level to another subvolume as 'default'.
> If top-level subvolume have some data (not present in 'default' snapshot),
> this space is wasted.
> 
> Are there way to 'merge' snapshot into top-level subvolume, or a way to
> completely remove subvolume 5 (without breaking fs)?

   You can't remove the top-level subvolume (id 5). All you can do is
mount it (with -o subvolid=5 or =0) and (carefully) delete the parts
that you don't need. Remember that all the other subvolumes are
visible in this view, so don't just rm -rf *, because you'll delete
everything in the FS including your currently active subvols.

   Hugo.

-- 
Hugo Mills             | emacs: Emacs Makes A Computer Slow.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |
