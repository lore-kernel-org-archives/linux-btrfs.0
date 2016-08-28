Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37486 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753756AbcH1Dmm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Aug 2016 23:42:42 -0400
Received: by mail-wm0-f50.google.com with SMTP id i5so43638921wmg.0
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Aug 2016 20:42:41 -0700 (PDT)
Received: from ?IPv6:2a01:5c0:1c:b661:e56d:b3b3:8ef7:7c7d? ([2a01:5c0:1c:b661:e56d:b3b3:8ef7:7c7d])
        by smtp.googlemail.com with ESMTPSA id u2sm6519353wmf.5.2016.08.27.20.42.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Aug 2016 20:42:39 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Subject: btrfstune settings
Message-ID: <fac36170-075c-db45-5aff-afa55bcd9e34@googlemail.com>
Date: Sun, 28 Aug 2016 05:42:39 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear btrfs experts, 

I hope this is the correct place to ask, the wiki and manpages did not help me on these questions. 

BTRFS has gained extended inode refs, skinny metadata and no-holes quite a while ago and these are now the defaults for new mkfs.btrfs. btrfstune can activate those features. 

However, I miss two things: 
- How do I see on an existing FS which of these features are on? 
  btrfstune (it seems) can only "set", but not "get" the feature flags. 
- Is it worthwhile / recommended / safe to activate those on existing FS? 
  Are there any steps (e.g. balancing metadata with -musage=0, I'd guess) needed to make them become active afterwards? 

If there is any documentation on this and I missed it, please RTFM me. 

Cheers and thanks a lot, 
	Oliver
