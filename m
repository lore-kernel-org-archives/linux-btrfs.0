Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32DBFC433C1
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Mar 2021 16:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0630C61A17
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Mar 2021 16:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbhCYQAz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 12:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhCYQAU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Mar 2021 12:00:20 -0400
X-Greylist: delayed 79 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 25 Mar 2021 09:00:20 PDT
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A45DC06174A
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Mar 2021 09:00:20 -0700 (PDT)
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 8D731745;
        Thu, 25 Mar 2021 15:58:57 +0000 (UTC)
Date:   Thu, 25 Mar 2021 20:58:57 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     "Wulfhorst, Heiner" <Heiner.Wulfhorst@claas.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Why doesn't btrfs find additional space after (VMware) disk
 extension?
Message-ID: <20210325205857.412ab914@natsu>
In-Reply-To: <8a4b55eb42bd42d181abe9d7c208607c@claas.com>
References: <8a4b55eb42bd42d181abe9d7c208607c@claas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, 25 Mar 2021 15:47:20 +0000
"Wulfhorst, Heiner" <Heiner.Wulfhorst@claas.com> wrote:

> But btrfs won't extend its filesystem:
> # btrfs filesystem resize max /
> Resize '/' of 'max'

...

> btrfs filesystem resize / 3:max

You got the right lead there, but I believe it's 

btrfs filesystem resize 3:max /

-- 
With respect,
Roman
