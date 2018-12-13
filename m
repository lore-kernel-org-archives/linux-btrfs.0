Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E1EC65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 07:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 867B420849
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 07:29:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 867B420849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=angband.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbeLMH3I (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 02:29:08 -0500
Received: from tartarus.angband.pl ([54.37.238.230]:46038 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbeLMH3I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 02:29:08 -0500
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1gXLQf-0001hb-8f; Thu, 13 Dec 2018 08:29:05 +0100
Date:   Thu, 13 Dec 2018 08:29:05 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     Nathan Dehnel <ncdehnel@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: SATA/SAS mixed pool
Message-ID: <20181213072905.ac352nclowixfhpt@angband.pl>
References: <CAEEhgEtryrEBv-PgZ5VkXEUcmXhx7JCoRrDhyLK5zP0-zOsESw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEEhgEtryrEBv-PgZ5VkXEUcmXhx7JCoRrDhyLK5zP0-zOsESw@mail.gmail.com>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 12, 2018 at 09:31:02PM -0600, Nathan Dehnel wrote:
> Is it possible/safe to replace a SATA drive in a btrfs RAID10 pool
> with an SAS drive?

For btrfs, a block device is a block device, it's not "racist".
You can freely mix and/or replace.  If you want to, say, extend a SD
card with NBD to remote spinning rust, it works well -- tested :p


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ Ivan was a worldly man: born in St. Petersburg, raised in
⢿⡄⠘⠷⠚⠋⠀ Petrograd, lived most of his life in Leningrad, then returned
⠈⠳⣄⠀⠀⠀⠀ to the city of his birth to die.
