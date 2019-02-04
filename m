Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2DCC282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 12:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EDB82087C
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 12:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbfBDMwv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 07:52:51 -0500
Received: from rigel.uberspace.de ([95.143.172.238]:51418 "EHLO
        rigel.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbfBDMwv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 07:52:51 -0500
Received: (qmail 11142 invoked from network); 4 Feb 2019 12:52:48 -0000
Received: from localhost (HELO webmail.rigel.uberspace.de) (127.0.0.1)
  by ::1 with SMTP; 4 Feb 2019 12:52:48 -0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 04 Feb 2019 13:52:48 +0100
From:   Moritz M <mailinglist@moritzmueller.ee>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org, linux-btrfs-owner@vger.kernel.org
Subject: Re: Help needed, server is unresponsive after btrfs balance
In-Reply-To: <4ecaf7ef-49cb-d7f6-3535-941e44e2f469@gmx.com>
References: <6c9257eb3b6451b67bd8b082e06a7735@moritzmueller.ee>
 <4ecaf7ef-49cb-d7f6-3535-941e44e2f469@gmx.com>
Message-ID: <36591d6b6e7c9875e512fddbc78139d3@moritzmueller.ee>
X-Sender: mailinglist@moritzmueller.ee
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> 
> You're using qgroups, it's known to cause huge performance overhead for
> balance.
> 
> We have upcoming patches to solve it, but it not going to mainline
> before v5.1 kernel.
> 
> So please disable qgroups if you're not using it actively.
> 

Thanks, was not aware that I turned it on. Is

btrfs quota disable /

enough for disabling qgroups?
