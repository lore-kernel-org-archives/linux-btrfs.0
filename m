Return-Path: <SRS0=XB0s=7L=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D21C433DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 May 2020 04:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62198207D3
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 May 2020 04:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbgE2E0Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 May 2020 00:26:16 -0400
Received: from magic.merlins.org ([209.81.13.136]:53112 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2E0P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 May 2020 00:26:15 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.92 #3)
        id 1jeWb1-0007pp-9w by authid <merlin>
        for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2020 21:26:15 -0700
Date:   Thu, 28 May 2020 21:26:15 -0700
From:   Marc MERLIN <marc@merlins.org>
To:     linux-btrfs@vger.kernel.org
Subject: Is SATA ALPM safe with btrfs now (no more corruption)?
Message-ID: <20200529042615.GA32752@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sysadmin: BOFH
X-URL:  http://marc.merlins.org/
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: marc@merlins.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

TLP allows SATA power management: SATA_LINKPWR_ON_BAT=max_performance

There are some old posts that talk about corruption if you enable this
with btrfs:
https://wiki.archlinux.org/index.php/TLP#Btrfs
says not to enable it

https://forum.manjaro.org/t/btrfs-corruption-with-tlp/25158

https://github.com/linrunner/TLP/issues/128
says it may not be safe

https://www.reddit.com/r/archlinux/comments/5tm5uh/btrfs_and_tlp/
also talks about corruption

https://www.reddit.com/r/archlinux/comments/4f5xvh/saving_power_is_the_btrfs_dataloss_warning_still/
say it's probably ok

My feeling is that it's probably ok nowadays with a 5.6+ kernel.

Would anyone disagree?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/  
