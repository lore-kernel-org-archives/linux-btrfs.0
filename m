Return-Path: <SRS0=lAVn=BI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F5AC433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Jul 2020 12:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C047E20829
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Jul 2020 12:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgG2MDZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 08:03:25 -0400
Received: from rin.romanrm.net ([51.158.148.128]:38192 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbgG2MDZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Jul 2020 08:03:25 -0400
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 82B0641A;
        Wed, 29 Jul 2020 12:03:23 +0000 (UTC)
Date:   Wed, 29 Jul 2020 17:03:23 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     spaarder <spaarder@hotmail.nl>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: using btrfs subvolume as a write once read many medium
Message-ID: <20200729170323.2fe0b452@natsu>
In-Reply-To: <VI1PR02MB58697B26A91E68507032D9CDAE700@VI1PR02MB5869.eurprd02.prod.outlook.com>
References: <VI1PR02MB58697B26A91E68507032D9CDAE700@VI1PR02MB5869.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 29 Jul 2020 09:02:14 +0200
spaarder <spaarder@hotmail.nl> wrote:

> Hello,
> 
> With all the ransomware attacks I am looking for a "write once read
> many" (WORM) solution, so that if an attacker manages to get root
> access on my backup server, it would be impossible for him to
> delete/encrypt my backups.

If the attacker gets root on the said server, they could just do
"dd if=/dev/zero of=/your/btrfs", and no amount of password-protected,
read-only or sealed subvolumes will save you.

If you want to be more secure against that, include offline (powered off)
media into your backup scheme, which is powered-on to synchronize e.g. only
for short periods of time and under close supervision.

Or, if practical for your budgets and data volumes, even not just hard disks,
but also tape or optical writable-once media (e.g Blu-ray).

There are also some creative ways you can makeshift a write-only remote server
using "the cloud", such as emailing encrypted backups to your own E-Mail
account at say Gmail, with passwords or even 2-factor authentication to that
account kept securely and separately from everything else. (Suitable for
smaller amounts of data, though).

> Using btrbk I already have readonly daily snapshots on my backupserver.
> Is there any way to password protect the changing of the properties of
> these subvolumes, so an attacker could not just simply set the RO
> property to false? Any support for a feature request?

-- 
With respect,
Roman
