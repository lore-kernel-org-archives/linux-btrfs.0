Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC78C433EF
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Jun 2022 16:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiFXQDl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 12:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiFXQDl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Jun 2022 12:03:41 -0400
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EB33C723
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2022 09:03:38 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5b07e355.dip0.t-ipconnect.de [91.7.227.85])
        by mail.itouring.de (Postfix) with ESMTPSA id 63BF0125BCF;
        Fri, 24 Jun 2022 18:03:35 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 18768F01600;
        Fri, 24 Jun 2022 18:03:35 +0200 (CEST)
Subject: Re: Memory not shared for files opened from different subvolumes
To:     Saikrishna Arcot <saiarcot895@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <b8011afe-fb24-3349-30eb-182a8792c67a@saikrishna-Lemur>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <c0de2bb7-0a4a-4ab1-ad6b-9a435bf6802c@applied-asynchrony.com>
Date:   Fri, 24 Jun 2022 18:03:35 +0200
MIME-Version: 1.0
In-Reply-To: <b8011afe-fb24-3349-30eb-182a8792c67a@saikrishna-Lemur>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2022-06-23 23:36, Saikrishna Arcot wrote:

[snip]

> My question is, is it possible to share the physical pages for the
> same file from two different mount points being opened? This would
> reduce the physical memory used in larger cases.

Not an immediate solution but more background info on the problem and
some ongoing research: https://lwn.net/Articles/895907/
Hope this helps.

-h
