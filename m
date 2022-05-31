Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB1D3C433EF
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 May 2022 20:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347579AbiEaUAL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 31 May 2022 16:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245004AbiEaUAJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 May 2022 16:00:09 -0400
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9123E60059
        for <linux-btrfs@vger.kernel.org>; Tue, 31 May 2022 12:59:50 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id 6D4B06D4;
        Tue, 31 May 2022 19:59:47 +0000 (UTC)
Date:   Wed, 1 Jun 2022 00:59:45 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Lucas =?UTF-8?B?UsO8Y2tlcnQ=?= <lucas.rueckert@gmx.de>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [HELP] open_ctree failed when mounting RAID1
Message-ID: <20220601005945.7c3d3730@nvm>
In-Reply-To: <9c3fec36-fc61-3a33-4977-a7e207c3fa4e@gmx.de>
References: <9c3fec36-fc61-3a33-4977-a7e207c3fa4e@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 31 May 2022 21:50:52 +0200
Lucas Rückert <lucas.rueckert@gmx.de> wrote:

> and dmesg reports:
> 
> BTRFS error (device sdb): open_ctree failed

This in itself is a generic error which doesn't give reasons or details.

dmesg should have reported more than that, could you post all messages that
happened right after after the "mount" command?

-- 
With respect,
Roman
