Return-Path: <SRS0=J01l=7X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C931C433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Jun 2020 08:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 404EE2064C
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Jun 2020 08:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgFJIeH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 04:34:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:54916 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbgFJIeH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jun 2020 04:34:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9EAEDABE3;
        Wed, 10 Jun 2020 08:34:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id ACA95DA872; Wed, 10 Jun 2020 10:33:59 +0200 (CEST)
Date:   Wed, 10 Jun 2020 10:33:59 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: add little-endian optimized key helpers
Message-ID: <20200610083359.GG27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20200609194926.9343-1-dsterba@suse.com>
 <SN4PR0401MB35987DAB480E00C23708C7019B830@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB35987DAB480E00C23708C7019B830@SN4PR0401MB3598.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 10, 2020 at 07:51:55AM +0000, Johannes Thumshirn wrote:
> One question, why endianity instead of endianess?
> I think the latter is more common (in fact I had to google 
> to see if the former even exists)

It exists but you're right that endianness (double n) is more common,
I'll fix it. Thanks.
