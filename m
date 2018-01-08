Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:33923 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932349AbeAHQUM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 11:20:12 -0500
Received: by mail-lf0-f45.google.com with SMTP id h140so12688281lfg.1
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jan 2018 08:20:11 -0800 (PST)
Message-ID: <5A539A3A.10107@gmail.com>
Date: Mon, 08 Jan 2018 17:20:10 +0100
From: ein <ein.net@gmail.com>
MIME-Version: 1.0
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Recommendations for balancing as part of regular maintenance?
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
In-Reply-To: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/08/2018 04:55 PM, Austin S. Hemmelgarn wrote:
> [...]
> 
> And here's the FAQ entry:
> 
> Q: Do I need to run a balance regularly?
> 
> A: In general usage, no. A full unfiltered balance typically takes a
> long time, and will rewrite huge amounts of data unnecessarily. You may
> wish to run a balance on metadata only (see Balance_Filters) if you find
> you have very large amounts of metadata space allocated but unused, but
> this should be a last resort.

IHMO three more sentencens and the answer would be more useful:
1. BTRFS balance command example with note check the man first.
2. What use case may cause 'large amounts of metadata space allocated
but unused'.


-- 
PGP Public Key (RSA/4096b):
ID: 0xF2C6EA10
SHA-1: 51DA 40EE 832A 0572 5AD8 B3C0 7AFF 69E1 F2C6 EA10
