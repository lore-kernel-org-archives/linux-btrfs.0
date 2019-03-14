Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 044ACC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 15:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA8332184E
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 15:41:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="IfKFHIf5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfCNPlJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:41:09 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:40597 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbfCNPlJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 11:41:09 -0400
Received: by mail-yw1-f67.google.com with SMTP id p64so1473393ywg.7
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 08:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Ncu6hJOPskCpdFvK59c8CkLAIhgJe147+fC/s+ZFKLw=;
        b=IfKFHIf5TrCTv/eQztvKtMS/Uv/cENcFyRQNCNklX5FJRtBAJ9/TJyWDJp7kRKvwXH
         WCwJhCiOCDWUrX08RVMops4PC938BugE8S9g8PgaBikFPIOL4XfWBxbrwaOW0V3nKkbS
         M1yz8ZUQF+nPJBSxIE2ovJiLvJNVWhS6+ban3kgo4BWF+ofePVtkbH2fwMOpO19r4jij
         /TLmIykEPhXC15jRx3iXx7A8X3gkrMmU4Ru70lo2j09YPxtV2JFhR24S0X46aIj9YgWS
         MKCE0ceW52N+q9nJkGHN171c/3jIqjHKgnhZRNMjVVbCNtscMalbL7u0lkiHsxFo3VBV
         1nLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Ncu6hJOPskCpdFvK59c8CkLAIhgJe147+fC/s+ZFKLw=;
        b=ngpXw4O92PG3OADzHdY+svXW2yFQNXHMlnN+hOPJdYHxl6kcwPskwFW4NQ/2aOtUZ8
         9VYoE4a5cW7c4RxnLGdFehiMVkd+ujShZa7KUdaQFm4j0hIwIO3IKb/rrfCazYcAOlwS
         iRA/Ld4KZCcQG1VZn29y7/GCCfOQVWo/nIB9GVwxVBnfJvTqbKC7rzcEa3+fzLlNOHKy
         v0lY6a2jDBj25enBwj/yO3dUH0Kr0Y9mYn1nZCU6nEsOEGAyecW6AUOaBbbejy75fYpe
         xGj67nbgvzm4yfaa/1+O8+DnMhTX9JfM5s4xpU8FU7zMW8TOtNLHYzNzeBlfqVGWLcJT
         guOw==
X-Gm-Message-State: APjAAAWQ6nHRSRQh7p3tCqDEzffXkhq+DjaS0ke+hz2j88rSpO/VzhUM
        RCE+PneEez65FsEz7w0tbl/Qk4lR+AqZ1Q==
X-Google-Smtp-Source: APXvYqweI7TM5OKXWW4Lulbz7BJHh0MSateaJV4Cxo+x2W+6hd6Mxt9w/ZwxPGyvM38LOMEQX8Sc6Q==
X-Received: by 2002:a81:3b4f:: with SMTP id i76mr40195945ywa.281.1552578068542;
        Thu, 14 Mar 2019 08:41:08 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::8f3])
        by smtp.gmail.com with ESMTPSA id 131sm5541538ywp.20.2019.03.14.08.41.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 08:41:07 -0700 (PDT)
Date:   Thu, 14 Mar 2019 11:41:06 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Kangjie Lu <kjlu@umn.edu>, pakki001@umn.edu,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix a NULL pointer dereference
Message-ID: <20190314154104.wtlmntw2tymvxjao@MacBook-Pro-91.local.dhcp.thefacebook.com>
References: <20190314075041.28966-1-kjlu@umn.edu>
 <b0b494f4-8686-8e50-faca-625d6f89bbe3@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b0b494f4-8686-8e50-faca-625d6f89bbe3@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 14, 2019 at 09:54:07AM +0200, Nikolay Borisov wrote:
> 
> 
> On 14.03.19 г. 9:50 ч., Kangjie Lu wrote:
> > btrfs_lookup_block_group may fail and return NULL. The fix goes
> > to out when it fails to avoid NULL pointer dereference.
> 
> Actually no, in this case btrfs_lookup_block_group must never fail
> because if we have an allocated eb then it must have been allocated from
> a bg.
> 

Agreed, we only get to btrfs_free_tree_block() if we are actually deleting the
extent buffer.  We would have had to read in the extent buffer first to get
here, which would have failed if there was no block group.  We can't get into
this situation with a specifically crafted file system to exploit this as we'd
bail out well before we could get to btrfs_free_tree_block().  Adding an
ASSERT() makes sure developers aren't doing anything stupid, but again we'd have
to be doing something _super_ stupid to hit it.  Thanks,

Josef
