Return-Path: <SRS0=+hsm=T6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A2EC28CC0
	for <linux-btrfs@archiver.kernel.org>; Thu, 30 May 2019 01:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE46B23BC5
	for <linux-btrfs@archiver.kernel.org>; Thu, 30 May 2019 01:14:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="YbFAuZLQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfE3BOG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 29 May 2019 21:14:06 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:17768 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfE3BOG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 May 2019 21:14:06 -0400
Date:   Thu, 30 May 2019 01:13:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1559178844;
        bh=au1r605/URpwNc8RTZa6uhept92DNPMkVi5tdst/eJ4=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=YbFAuZLQEfEIT8Vcwkoc4vLfxlt3IvXiviz0unlHbhKm2RVEtH+TcLWlLMj0e7UZq
         2CfwjHovmE9sfGepcRiAilA1zOt7gxoTWp3JZM/8F6aXjtv0xrx7VlMgP7YxI+bQh7
         RXzvqi7+A3izFKCpBs7xhtKECk0fE1IWnqz5S2+w=
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   Newbugreport <newbugreport@protonmail.com>
Reply-To: Newbugreport <newbugreport@protonmail.com>
Subject: sub-file dedup
Message-ID: <0tUXYHrSBzkwOdUp7Az8PrnXzFeWPycFN82KoFJ-fkvTjnrYwPP77RoZbDkO6RjkpPBjQlL4p2tUKywSpxErBQJTVJk8zexKNWjW6k6W0CE=@protonmail.com>
Feedback-ID: d6Wm0FJd7i1jFe-FGWugBSsNs-8bq-rQNjTlE-phxxZwlQCWXnoyvi9qcr4gYuV_Fena2XhvJGc4qqroBLRNtw==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I'm experimenting with the rsync algorithm for btrfs deduplication. Every o=
ther deduplication tool I've seen works against whole files. I'm concerned =
about deduping chunks under 4k and about files with scattered extents.

Are there best practices for deduplication on btrfs?
