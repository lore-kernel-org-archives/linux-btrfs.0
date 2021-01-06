Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7884CC433DB
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Jan 2021 20:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 467542313A
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Jan 2021 20:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbhAFUIN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Jan 2021 15:08:13 -0500
Received: from smtp01.belwue.de ([129.143.71.86]:49678 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbhAFUIN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jan 2021 15:08:13 -0500
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 84BBE8E04
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Jan 2021 21:07:30 +0100 (MET)
Date:   Wed, 6 Jan 2021 21:07:30 +0100
From:   Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How to properly setup for snapshots
Message-ID: <20210106200730.GB21074@tik.uni-stuttgart.de>
Mail-Followup-To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <AM9P191MB165033908B55F8312178D90AE2CB0@AM9P191MB1650.EURP191.PROD.OUTLOOK.COM>
 <AM9P191MB1650A1159D554207CB5D738AE2C00@AM9P191MB1650.EURP191.PROD.OUTLOOK.COM>
 <a68cd516-d6a2-b7ee-744b-d1b0ee83c2df@georgianit.com>
 <20201221223701.0845e9ad@natsu>
 <3d45b062-a004-277e-db8b-6826c6b342bb@gmail.com>
 <AM9P191MB1650526777331A5E93DAADD3E2C00@AM9P191MB1650.EURP191.PROD.OUTLOOK.COM>
 <8b6c458b-5fab-2209-9d5a-d40f55de5c00@gmail.com>
 <AM9P191MB1650A8C71F588CC759C7FAB6E2C00@AM9P191MB1650.EURP191.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM9P191MB1650A8C71F588CC759C7FAB6E2C00@AM9P191MB1650.EURP191.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon 2020-12-21 (20:51), Claudius Ellsel wrote:

> With management of snapshots I did not mean cron (automating stuff), but
> having an easy and error prone interface for creating and interacting
> with already created snapshots (like deleting old ones or comparing
> things).

http://fex.belwue.de/snaprotate.html

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<AM9P191MB1650A8C71F588CC759C7FAB6E2C00@AM9P191MB1650.EURP191.PROD.OUTLOOK.COM>
