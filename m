Return-Path: <SRS0=1fJ+=ZE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6473FC43331
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Nov 2019 14:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 418AE222C5
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Nov 2019 14:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfKLO2Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 09:28:24 -0500
Received: from briare1.fullpliant.org ([78.227.24.35]:57492 "HELO
        briare1.fullpliant.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726008AbfKLO2Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Nov 2019 09:28:24 -0500
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Nov 2019 09:28:24 EST
From:   Hubert Tonneau <hubert.tonneau@fullpliant.org>
To:     linux-btrfs@vger.kernel.org
Subject: Avoiding BRTFS RAID5 write hole
Date:   Tue, 12 Nov 2019 15:13:26 GMT
Message-ID: <0JG8IAF11@briare1.fullpliant.org>
X-Mailer: Pliant 114
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

In order to close the RAID5 write hole, I prepose the add a mount option that would change RAID5 (and RAID6) behaviour :

. When overwriting a RAID5 stripe, first convert it to RAID1 (convert it to RAID1C3 if it was RAID6)

. Have a background process that converts RAID1 stripes to RAID5 (RAID1C3 to RAID6)

Expected advantages are :
. the low level features set basically remains the same
. the filesystem format remains the same
. old kernels and btrs-progs would not be disturbed

The end result would be a mixed filesystem where active parts are RAID1 and archives one are RAID5.

Regards,
Hubert Tonneau
