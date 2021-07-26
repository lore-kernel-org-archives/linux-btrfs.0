Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345F1C4338F
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Jul 2021 15:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1171E60F51
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Jul 2021 15:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbhGZOcO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 10:32:14 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60382 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234725AbhGZOcN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jul 2021 10:32:13 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id EA40021F5F;
        Mon, 26 Jul 2021 15:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1627312356;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D9NOou/vwXk1Ftp7PwQWuweDzZF1eFYI7/fzkzlbd7Q=;
        b=Sc+IWhtIgG0jfGanPLryNMMkJTh9UwJec4gvrJH14r074KmvJdKMzC4fdLujg3Bzfmm5D1
        91gL0JcuTJLKxW+Bz8BNMjtj7s5c6sB5Gr2Bs/dDPH63eJTiQxeGnk7G5OkVFnWu+CQfyz
        PxvAOkl3iwXudv2j2+PJckijTUvyncE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1627312356;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D9NOou/vwXk1Ftp7PwQWuweDzZF1eFYI7/fzkzlbd7Q=;
        b=HyzfFgdajlBKyheC/A5eTBuGR75uWmb0kZobv5kQRek45gYTBrB5fT1lqSvDAUuD35FSZc
        WgfAJ5IbZf+gXQAw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id E2436A3B85;
        Mon, 26 Jul 2021 15:12:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 242C5DA8D8; Mon, 26 Jul 2021 17:09:53 +0200 (CEST)
Date:   Mon, 26 Jul 2021 17:09:53 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/10] btrfs: add and use simple page/bio to
 inode/fs_info helpers
Message-ID: <20210726150953.GG5047@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1627300614.git.dsterba@suse.com>
 <4d3594dcca4dd8a8e58b134409922c2787b6a757.1627300614.git.dsterba@suse.com>
 <6cac34b2-39ba-f344-d601-b78a3f0c7698@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6cac34b2-39ba-f344-d601-b78a3f0c7698@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jul 26, 2021 at 08:41:57PM +0800, Qu Wenruo wrote:
> 
> 
> On 2021/7/26 下午8:15, David Sterba wrote:
> > We have lots of places where we want to obtain inode from page, fs_info
> > from page and open code the pointer chains.
> 
> All those inode/fs_info grabbing from just a page is dangerous.
> 
> If an anonymous page is passed in unintentionally, it can easily crash
> the system.
> 
> Thus at least some ASSERT() here is a must to me.

But we can only check if the pointer is valid, any page can have a valid
pointer but not our fs_info. If it crashes on an unexpected page than
what can we do in the code anyway?
