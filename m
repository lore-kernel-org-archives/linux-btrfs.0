Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f169.google.com ([209.85.128.169]:42675 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3DNFSk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Apr 2013 01:18:40 -0400
Received: by mail-ve0-f169.google.com with SMTP id d10so3464929vea.28
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Apr 2013 22:18:39 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 14 Apr 2013 01:18:39 -0400
Message-ID: <CABF9=8jnQQCuDGeZ0pAmFujtaDtLNs3GdFO0DFXq1Nn4yTZAmg@mail.gmail.com>
Subject: btrfs scrubber: clarification on scrub_chunk
From: George Amvrosiadis <gamvrosi@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

In scrub_chunk() of scrub.c, the following snippet appears:

2531         for (i = 0; i < map->num_stripes; ++i) {
2532                 if (map->stripes[i].dev->bdev == scrub_dev->bdev &&
2533                     map->stripes[i].physical == dev_offset) {
2534                         ret = scrub_stripe(sctx, map, scrub_dev, i,
2535                                            chunk_offset, length,
2536                                            is_dev_replace);
2537                         if (ret)
2538                                 goto out;
2539                 }
2540         }

Could someone please clarify line 2533? My intuition from the code so
far was that
this should be "map->stripes[i].physical == dev_offset + i *
stripe_size", otherwise
the condition would fail for all but the first stripe of every chunk
(effectively scrubbing
only that).

Thanks,

--
George Amvrosiadis, B.Sc., Ph.D. Student
Graduate Students' Union Representative
Computer Science, University of Toronto
