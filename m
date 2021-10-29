Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D90C433EF
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Oct 2021 16:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A617A61177
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Oct 2021 16:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhJ2Q6I (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Oct 2021 12:58:08 -0400
Received: from tartarus.angband.pl ([51.83.246.204]:42394 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhJ2Q6H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Oct 2021 12:58:07 -0400
X-Greylist: delayed 1729 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Oct 2021 12:58:07 EDT
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.94.2)
        (envelope-from <kilobyte@angband.pl>)
        id 1mgUgI-007lEQ-Rr; Fri, 29 Oct 2021 18:24:38 +0200
Date:   Fri, 29 Oct 2021 18:24:38 +0200
From:   Adam Borowski <kilobyte@angband.pl>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs pre-release 5.15-rc1
Message-ID: <YXwgRuMiS2OFYP8+@angband.pl>
References: <20211029155346.19985-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211029155346.19985-1-dsterba@suse.com>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 29, 2021 at 05:53:46PM +0200, David Sterba wrote:
> The noticeable changes are in the mkfs defaults:
> 
>   * no-holes
>   * free-space-tree
      ^^^^^^^^^^^^^^^
>   * DUP for metadata unconditionally

\o/ !!!

-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ An imaginary friend squared is a real enemy.
⠈⠳⣄⠀⠀⠀⠀
