Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:37452 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdJEKHg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Oct 2017 06:07:36 -0400
Received: by mail-wr0-f196.google.com with SMTP id v38so6360176wrc.4
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Oct 2017 03:07:35 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 0/1] Btrfs: populate heuristic with logic
Date: Thu,  5 Oct 2017 13:07:25 +0300
Message-Id: <20171005100726.16438-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As core part of heuristic merged to for-next tree,
I send another patch with shannon entropy calculation,
as that metric will cover another part of cases.

That also will cover most of silesia corpus data.

P.S.
i reverse ported it, so:
https://github.com/Nefelim4ag/companalyze

For now that only for guess kernel counters for specific data,
i.e. no policy logic. Only RAW counters.
To know if tunning needed on specific data case and easy check
that heuristic see for that data.

Timofey Titovets (1):
  Btrfs: heuristic add shannon entropy calculation

 fs/btrfs/compression.c | 314 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 313 insertions(+), 1 deletion(-)

--
2.14.2
