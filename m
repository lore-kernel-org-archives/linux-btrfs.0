Return-Path: <SRS0=5Fjf=AM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95729C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed,  1 Jul 2020 20:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81FA72082F
	for <linux-btrfs@archiver.kernel.org>; Wed,  1 Jul 2020 20:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgGAUOW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 16:14:22 -0400
Received: from mail.nethype.de ([5.9.56.24]:43045 "EHLO mail.nethype.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgGAUOV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Jul 2020 16:14:21 -0400
Received: from [10.0.0.5] (helo=doom.schmorp.de)
        by mail.nethype.de with esmtp (Exim 4.92)
        (envelope-from <schmorp@schmorp.de>)
        id 1jqj7c-0024TA-26; Wed, 01 Jul 2020 20:14:20 +0000
Received: from [10.0.0.1] (helo=cerebro.laendle)
        by doom.schmorp.de with esmtp (Exim 4.92)
        (envelope-from <schmorp@schmorp.de>)
        id 1jqj7b-0006zo-TE; Wed, 01 Jul 2020 20:14:19 +0000
Received: from root by cerebro.laendle with local (Exim 4.92)
        (envelope-from <root@schmorp.de>)
        id 1jqj7b-0000gO-Su; Wed, 01 Jul 2020 22:14:19 +0200
Date:   Wed, 1 Jul 2020 22:14:19 +0200
From:   Marc Lehmann <schmorp@schmorp.de>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: first mount(s) after unclean shutdown always fail
Message-ID: <20200701201419.GB1889@schmorp.de>
References: <20200701005116.GA5478@schmorp.de>
 <36fcfc97-ce4c-cce8-ee96-b723a1b68ec7@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36fcfc97-ce4c-cce8-ee96-b723a1b68ec7@gmx.com>
OpenPGP: id=904ad2f81fb16978e7536f726dea2ba30bc39eb6;
 url=http://pgp.schmorp.de/schmorp-pgpkey.txt; preference=signencrypt
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 01, 2020 at 09:30:25AM +0800, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> This looks like an old fs with some bad accounting numbers.

Yeah, but it's not.

> Have you tried btrfs rescue fix-device-size?

Why would I want to try this?

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\
