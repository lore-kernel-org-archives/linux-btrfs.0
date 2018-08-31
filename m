Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f173.google.com ([209.85.208.173]:34803 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbeHaWwa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 18:52:30 -0400
Received: by mail-lj1-f173.google.com with SMTP id f8-v6so10858543ljk.1
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 11:43:43 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 31 Aug 2018 12:43:41 -0600
Message-ID: <CAJCQCtQv6RyGsK69451xu3pA_2pVPLkektT9rCVAtDL6VXwgGQ@mail.gmail.com>
Subject: bug: btrfs-progs scrub -R flag doesn't show per device stats
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-progs v4.17.1

man btrfs-scrub:

           -R
               print raw statistics per-device instead of a summary


However, on a two device Btrfs volume, -R does not show per device
statistics. See screenshot:

https://drive.google.com/open?id=1xmt_NHGlNJPc8I0F4_OZxgGe9b3quCnD

Additionally, the description of -d and -R doesn't help me distinquish
between the two. -R says "instead of a summary" so that suggests -d
will summarize but isn't explicitly stated.



-- 
Chris Murphy
