Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35035 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965752AbcJ0OIv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 10:08:51 -0400
Received: by mail-wm0-f41.google.com with SMTP id e69so37303958wmg.0
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Oct 2016 07:08:50 -0700 (PDT)
Received: from system (HSI-KBW-046-005-000-248.hsi8.kabel-badenwuerttemberg.de. [46.5.0.248])
        by smtp.gmail.com with ESMTPSA id x138sm2757048wme.14.2016.10.27.04.30.12
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Oct 2016 04:30:12 -0700 (PDT)
Date: Thu, 27 Oct 2016 13:30:11 +0200
From: Saint Germain <saintger@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Identifying reflink / CoW files
Message-ID: <20161027133011.631cf1e5@system>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Following the previous discussion:
https://www.spinics.net/lists/linux-btrfs/msg19075.html

I would be interested in finding a way to reliably identify reflink /
CoW files in order to use deduplication programs (like fdupes, jdupes,
rmlint) efficiently.

Using FIEMAP doesn't seem to be reliable according to this discussion
on rmlint:
https://github.com/sahib/rmlint/issues/132#issuecomment-157665154

Is there another way that deduplication programs can easily use ?

Thanks
