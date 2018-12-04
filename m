Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10E4C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 12:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E2C12087F
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 12:22:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E2C12087F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=angband.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbeLDMWy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 07:22:54 -0500
Received: from tartarus.angband.pl ([54.37.238.230]:39972 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbeLDMWy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Dec 2018 07:22:54 -0500
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1gU9iy-000176-Fr; Tue, 04 Dec 2018 13:22:48 +0100
Date:   Tue, 4 Dec 2018 13:22:48 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/9] btrfs-progs: Fix Wmaybe-uninitialized warning
Message-ID: <20181204122248.liocpfkyqodb5vco@angband.pl>
References: <20181116075426.4142-1-wqu@suse.com>
 <20181116075426.4142-8-wqu@suse.com>
 <20181204121704.GL17773@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181204121704.GL17773@twin.jikos.cz>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 04, 2018 at 01:17:04PM +0100, David Sterba wrote:
> On Fri, Nov 16, 2018 at 03:54:24PM +0800, Qu Wenruo wrote:
> > The only location is the following code:
> > 
> > 	int level = path->lowest_level + 1;
> >  	BUG_ON(path->lowest_level + 1 >= BTRFS_MAX_LEVEL);
> >  	while(level < BTRFS_MAX_LEVEL) {
> > 		slot = path->slots[level] + 1;
> > 		...
> > 	}
> > 	path->slots[level] = slot;
> > 
> > Again, it's the stupid compiler needs some hint for the fact that
> > we will always enter the while loop for at least once, thus @slot should
> > always be initialized.
> 
> Harsh words for the compiler, and I say not deserved. The same code
> pasted to kernel a built with the same version does not report the
> warning, so it's apparently a missing annotation of BUG_ON in
> btrfs-progs that does not give the right hint.

It's be nice if the C language provided a kind of a while loop that executes
at least once...

-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ Ivan was a worldly man: born in St. Petersburg, raised in
⢿⡄⠘⠷⠚⠋⠀ Petrograd, lived most of his life in Leningrad, then returned
⠈⠳⣄⠀⠀⠀⠀ to the city of his birth to die.
