Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C48CECDE43
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 20:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E89242145D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 20:24:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="AaEbPwvI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E89242145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbeJSE0I (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 00:26:08 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:45406 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725751AbeJSE0I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 00:26:08 -0400
Received: by mail-qt1-f169.google.com with SMTP id e10-v6so35854152qtq.12
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 13:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=DWidnD6qko/sL4ed97MdEuO7mHJAyViTAX5kCV+6cyc=;
        b=AaEbPwvIQ2uGM6aHQ3euKHdNj9EWEgUN/aAWClr4BNjuZiV6sYn0RLHAKPODu9L+21
         It7zKNOR8t4h8dy8WuSA8VLm8gdQgFnZZG8TCqZLHdJBcWGhh+HD7IJlaox4FetBBFL2
         vH3mWAR5w+6QRzx3xgXDCUNFbz91FarZqclXCcOZYT+pPgNeuCR8osS0rJblLspEcig3
         iSrMhaN7aNcVI6/blu1MxEbaNIUEYCiRt6EvB95nyXS9yHaxFALWO2EX8bx0EPgsFe/Q
         IZxe9iXQMiXWLbBsDkvwhbnnlEqaKPCsiVOENxGCJNMp0xwgu1Y36SrlsG1i+DbOnAi+
         Z60Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=DWidnD6qko/sL4ed97MdEuO7mHJAyViTAX5kCV+6cyc=;
        b=mAsxO1nXiTfEbXPc85FHXjYy1hTnMOkRllVCfWZY1kgbJlFLFz3N3jSDWLSSaLvckN
         TtmpkXuucPiCPtdvEMB2vouiQImZDms2W2nTOLpWoqYkzkhW0GQ/1+16RkPcL6wuK+GB
         /Yhqo0clxis3REz0d2t60TV9lhiGEHWmNvEfWOq10GnoTb5vn1sfQA7nQcvDIl02nIs6
         r6odTubCcmOY4E50LkK0f4ftWKtk9UQnYVxuZxy3/RfnV9mhPXZbn3XhA/cwSbQc9FVp
         3dPqxLqMfc/Yxs85tWhQceXnEkywe1clTwuJitJ0iq6m0oEdjoctg6yuqwbipDXB7KXc
         vShA==
X-Gm-Message-State: ABuFfojxaOl8QXfrcVWEWtmraCWfFRA5LiJLF/znlVsuPULlDML5U94A
        kzvDGN25YcfHc1HjgMxaWhATSVM6WqPJsA==
X-Google-Smtp-Source: ACcGV621niN4CxiCk1QbZve+IXGD5RNKB8F0Jf8D1W8k6JAqYonGTomE0k+mgIsNeKz01saE6vuAaQ==
X-Received: by 2002:a0c:95e6:: with SMTP id t35mr31999009qvt.163.1539894207297;
        Thu, 18 Oct 2018 13:23:27 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id q24-v6sm14344124qtb.26.2018.10.18.13.23.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Oct 2018 13:23:26 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, david@fromorbit.com,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, riel@fb.com, linux-mm@kvack.org
Subject: [PATCH 0/7][V3] drop the mmap_sem when doing IO in the fault path
Date:   Thu, 18 Oct 2018 16:23:11 -0400
Message-Id: <20181018202318.9131-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Getting some production testing running on these patches shortly to verify they
are ready for primetime, but in the meantime they've had a bunch of xfstests
runs on xfs, btrfs, and ext4 using kvm-xfstests.

v2->v3:
- dropped the RFC, ready for a real review.
- fixed a kbuild error for !MMU configs.
- dropped the swapcache patches since Johannes is still working on those parts.

v1->v2:
- reworked so it only affects x86, since its the only arch I can build and test.
- fixed the fact that do_page_mkwrite wasn't actually sending ALLOW_RETRY down
  to ->page_mkwrite.
- fixed error handling in do_page_mkwrite/callers to explicitly catch
  VM_FAULT_RETRY.
- fixed btrfs to set ->cached_page properly.

This time I've verified that the ->page_mkwrite retry path is actually getting
used (apparently I only verified the read side last time).  xfstests is still
running but it passed the couple of mmap tests I ran directly.  Again this is an
RFC, I'm still doing a bunch of testing, but I'd appreciate comments on the
overall strategy.

-- Original message --

Now that we have proper isolation in place with cgroups2 we have started going
through and fixing the various priority inversions.  Most are all gone now, but
this one is sort of weird since it's not necessarily a priority inversion that
happens within the kernel, but rather because of something userspace does.

We have giant applications that we want to protect, and parts of these giant
applications do things like watch the system state to determine how healthy the
box is for load balancing and such.  This involves running 'ps' or other such
utilities.  These utilities will often walk /proc/<pid>/whatever, and these
files can sometimes need to down_read(&task->mmap_sem).  Not usually a big deal,
but we noticed when we are stress testing that sometimes our protected
application has latency spikes trying to get the mmap_sem for tasks that are in
lower priority cgroups.

This is because any down_write() on a semaphore essentially turns it into a
mutex, so even if we currently have it held for reading, any new readers will
not be allowed on to keep from starving the writer.  This is fine, except a
lower priority task could be stuck doing IO because it has been throttled to the
point that its IO is taking much longer than normal.  But because a higher
priority group depends on this completing it is now stuck behind lower priority
work.

In order to avoid this particular priority inversion we want to use the existing
retry mechanism to stop from holding the mmap_sem at all if we are going to do
IO.  This already exists in the read case sort of, but needed to be extended for
more than just grabbing the page lock.  With io.latency we throttle at
submit_bio() time, so the readahead stuff can block and even page_cache_read can
block, so all these paths need to have the mmap_sem dropped.

The other big thing is ->page_mkwrite.  btrfs is particularly shitty here
because we have to reserve space for the dirty page, which can be a very
expensive operation.  We use the same retry method as the read path, and simply
cache the page and verify the page is still setup properly the next pass through
->page_mkwrite().

I've tested these patches with xfstests and there are no regressions.  Let me
know what you think.  Thanks,

Josef

