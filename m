Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B7DC433F5
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Mar 2022 17:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352263AbiCXR20 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 13:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351424AbiCXR2Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Mar 2022 13:28:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E56FA8EF6;
        Thu, 24 Mar 2022 10:26:52 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1D122210F4;
        Thu, 24 Mar 2022 17:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648142811;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1CdmV+6MVrtWsMxYK45xAE79HJoZaGMzpGQG+Nf1BLE=;
        b=KErdjg3/LhnV/qcEtYRWON2Inuv41ze44PaxHAyBpZyD/uEf3mBEXDeBpk80SmV/SWrT5I
        k2ycf/RxovxGycI5/+YwbWMmsGc8IPUYh+Md42MjCdKKyForM0wM3LBKKGZiYt8wmmuKO4
        jBwM/EihONQ+FcWmvdMk8wrr7EJAmx8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648142811;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1CdmV+6MVrtWsMxYK45xAE79HJoZaGMzpGQG+Nf1BLE=;
        b=bOdoDnSCb2J0tWMzORsK2lB0mNpJEhw3PHrAPdAwY9hV6Nbx25iS6mGL0hpWpulHAGzZyF
        vgm2kEYXci5PfrAQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id D53E2A3B82;
        Thu, 24 Mar 2022 17:26:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EABA1DA7F3; Thu, 24 Mar 2022 18:22:55 +0100 (CET)
Date:   Thu, 24 Mar 2022 18:22:55 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Haowen Bai <baihaowen@meizu.com>, "clm@fb.com" <clm@fb.com>,
        "josef@toxicpanda.com" <josef@toxicpanda.com>,
        "dsterba@suse.com" <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: btrfs: Remove redundant condition
Message-ID: <20220324172255.GJ2237@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Haowen Bai <baihaowen@meizu.com>, "clm@fb.com" <clm@fb.com>,
        "josef@toxicpanda.com" <josef@toxicpanda.com>,
        "dsterba@suse.com" <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1647999958-1496-1-git-send-email-baihaowen@meizu.com>
 <PH0PR04MB7416707094AF9C6A42F34D8B9B189@PH0PR04MB7416.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR04MB7416707094AF9C6A42F34D8B9B189@PH0PR04MB7416.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 23, 2022 at 07:54:39AM +0000, Johannes Thumshirn wrote:
> On 23/03/2022 02:47, Haowen Bai wrote:
> > The logic !A || A && B is equivalent to !A || B. so we can
> > make code clear.
> > 
> > Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> > ---
> 
> Well I guess as this is the 3rd time someone wants to do this:
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Ok then, added to misc-next.
