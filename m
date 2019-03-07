Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77696C43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 09:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FB8620835
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 09:34:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="Q0yOVCoH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfCGJe1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 04:34:27 -0500
Received: from mail-io1-f48.google.com ([209.85.166.48]:39698 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfCGJe1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2019 04:34:27 -0500
Received: by mail-io1-f48.google.com with SMTP id x3so12882308ior.6
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Mar 2019 01:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=LmFAdedJTtSF8+hERvo5cnFDZrLSIgoTm04Z2nQkVBI=;
        b=Q0yOVCoHZvX5X9MmuacaQlw+e6/xX4zFnE0sA8dJB8XWeEvNSuHWn6lL/3xu+DTTZ4
         wi5T43nO6RbH99/oG4LQhtuDx4n/VqqlKUDKawnYtn+yYr4uJraILQI19BlTMc+TJqJ6
         n65GKq/PnJP1Fz8Bi/+XPUM7TAAHRMatUtde3/Pg/UHekC2SW/SGxrNgdPmUqj4eVPJR
         BwTr30g9PusfgBEd3Vx9BsNd5JZS5abDcG+gVQ+yCh+FVHfEmNacm5o60/D0y+DitYxR
         /EyvxsHYtyKoSGgXD8oXxqqvBccjQ0zs+JxMQYvO7H463izRH1ce5Wq0MpZ2rA0gfG+4
         WpQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=LmFAdedJTtSF8+hERvo5cnFDZrLSIgoTm04Z2nQkVBI=;
        b=Ano7H3Drs79r85PMpJFYzSBDCbGPLyvY1jqWxqb++l8pIxmTsfUrKqZ+p2FoLhYPuG
         Q11QzA/8rielpDMHcBEIaG3z0rE1Jo314LV+TZj2htHPO4LDkeaaJtjfRBp9CxvVDOFB
         VtXVR1a88RFA92nfbk7EoDQuODH54lh+R8p18mpUaGFwJw9wl6O8JuIdEBi4iFa4v+xl
         y+5X336bzBUMlj2c6LO7odw0Itb1CeloiVyyqcDVoX0lpwe04HsY+gk6g51s2AENOhtM
         w8Dp90BjEGdFvH7nQz6XJ5crUdwifaXEDlYibE9uYXuvBjKgTt/3BJbWIhi1BWsl8to6
         frtw==
X-Gm-Message-State: APjAAAVPossZuAxac4hc94Abm0E1XWhuunkkybTxcB5g2539sRUP1wEv
        1esE9w9m0j/CLprXvj15tRS/i7FAVBmxM4i7wWyINg==
X-Google-Smtp-Source: APXvYqzO3QI3KPaxqhnMWds8ZfrvEqytov6WuMq0688kFwVvCLcTKUe3WHK5Mu5zrLA1zbhL0QVPKC6EPqAdfqHhb3I=
X-Received: by 2002:a5e:de0b:: with SMTP id e11mr6314198iok.73.1551951265891;
 Thu, 07 Mar 2019 01:34:25 -0800 (PST)
MIME-Version: 1.0
From:   Alex Lyakas <alex@zadara.com>
Date:   Thu, 7 Mar 2019 11:34:14 +0200
Message-ID: <CAOcd+r1haLQOKbHT5QtayGkmP4Wyy_CU2KLPupq0f3iKyx0mZA@mail.gmail.com>
Subject: Btrfs: cut down on loops through the allocator - a5e681d9bd641c4f0677e87d3a0c92a8f4f16293
To:     Josef Bacik <jbacik@fb.com>
Cc:     Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Josef,

This commit added the following code in find_free_extent:
                        ret = do_chunk_alloc(trans, root, flags,
                                             CHUNK_ALLOC_FORCE);
+
+                       /*
+                        * If we can't allocate a new chunk we've already looped
+                        * through at least once, move on to the NO_EMPTY_SIZE
+                        * case.
+                        */
+                       if (ret == -ENOSPC)
+                               loop = LOOP_NO_EMPTY_SIZE;
+

With this, I am hitting an early enospc, with the following scenario:
- assume a file system is almost full, and has 5GB free space on the device left
- there are multiple threads (say 6) calling find_free_extent() in
parallel with empty_size=0
- they all don't find a block group to allocate from, so they call
do_chunk_alloc()
- 5x1GB chunks are allocated, but additional do_chunk_alloc call()
returns -ENOSPC
- As a result, this thread moves to LOOP_NO_EMPTY_SIZE, but since
empty_size is already zero, it returns -ENOSPC to the caller. But in
fact we have 5GB free space to allocate from. We just need to to an
extra loop.

Basically, do_chunk_alloc() returning -ENOSPC does not mean that there
is no space. It can happen that parallel chunk allocations exhausted
the device, but we have plenty of space.

Furthermore, this thread now sets space_info->max_extent_size. And
from now on, any allocation that needs more than max_extent_size will
immediately fail. But if we unmount and mount again, we will have
plenty of space.

This happens to me on 4.14, but I think the mainline still has the same logic.

Thanks,
Alex.
