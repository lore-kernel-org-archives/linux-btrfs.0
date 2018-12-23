Return-Path: <SRS0=mU8m=PA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A02B8C43387
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 06:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70D7921903
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 06:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbeLWGQS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 23 Dec 2018 01:16:18 -0500
Received: from tartarus.angband.pl ([54.37.238.230]:51548 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbeLWGQS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Dec 2018 01:16:18 -0500
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1gax3V-0002ie-7J; Sun, 23 Dec 2018 07:16:05 +0100
Date:   Sun, 23 Dec 2018 07:16:05 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     Paul Jones <paul@pauljones.id.au>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "devzero@web.de" <devzero@web.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: compress-force not really forcing compression?
Message-ID: <20181223061605.qrl5zsi36kpyltql@angband.pl>
References: <trinity-138fb9ef-e164-4c58-8ba8-04eaa9813254-1545234086993@3c-app-webde-bs26>
 <79977718-ac8f-3a62-529d-e9046c8066b2@gmx.com>
 <f527b243-4379-ec32-a6f2-3f04c72fb8d9@suse.com>
 <SYCPR01MB5086BDC3A10DC10383C12EFB9EBA0@SYCPR01MB5086.ausprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SYCPR01MB5086BDC3A10DC10383C12EFB9EBA0@SYCPR01MB5086.ausprd01.prod.outlook.com>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Dec 23, 2018 at 12:24:02AM +0000, Paul Jones wrote:
> > IMHO the more pertinent question is :
> > 
> > If a file has portions which are not easily compressible does that imply all
> > future writes are also incompressible. IMO no, so I think what will be prudent
> > is remove FORCE_COMPRESS altogether and make the code act as if it's
> > always on.
> > 
> > Any opinions?
> 
> 
> That is a good idea.  If I turn on compression I would expect everything
> to be compressed, except in cases where there is no size benefit.

I expect that the vast majority of files consist of blocks of similar
compressibility.  Thus, finding a block that fails to compress strongly
suggests other blocks are either incompressible as well or compress only
minimally.  Refusing to waste time, electricity and fragmentation in such
case is a good default, I think.

But, if you believe this should be changed, there's an easy experiment you
can try: for all files on your filesystem, chop every file into 128KB pieces
and compress each of them with your chosen algorithm.  Noting the compressed
size of every block in a file that had at least one block fail to compress
would give us some data.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ Ivan was a worldly man: born in St. Petersburg, raised in
⢿⡄⠘⠷⠚⠋⠀ Petrograd, lived most of his life in Leningrad, then returned
⠈⠳⣄⠀⠀⠀⠀ to the city of his birth to die.
