Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8956FC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 13:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 426482086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 13:54:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FVbq1Ny/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 426482086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gelma.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbeK1AwC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 19:52:02 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:37060 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbeK1AwC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 19:52:02 -0500
Received: by mail-wm1-f53.google.com with SMTP id g67so8830459wmd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 05:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=HxnCcDVhO+vTPHIcxvveB9qH6e3TbAWu09Ju4i4SSJY=;
        b=FVbq1Ny/1wewEOEHTrH8qpK4Q4xgNZerZ3Brc7iO2FxcaUP/ARg9IDMoHBi6Erzwn5
         qBWd61kVG1oXiOSRWwwLricDo+kwlySpBJ8giFJfm6zZvD3E8S+ZonvE9SpZByphER9v
         lv+J7S1wAKvFlhTPv46HEJwHWZhCgQ9ijyY5ZdDWFaJKcrOEL7lmFMSSmooxI4XI3iQ/
         hfIcBGN9J2dvzGEVEsGq6W8F2N43xt0luetgLImFJ+r18Ujt1do+JfowtODSvfenjcNs
         Z0q/7yy0FimgStuNrB7ROtJIya+665Ww+rXRul4cjUcB/LIl7oY72sHSK3ijHLtBksEZ
         x6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=HxnCcDVhO+vTPHIcxvveB9qH6e3TbAWu09Ju4i4SSJY=;
        b=lvZNTBTESxYgpxNED9y6jxVaKNe04u5tYQEFYN4g1drfuDg0FQo9qaPMCkkoU3jKKt
         bd6JGKHswcFqTBlvoiQwXKOwtFKwJYRcv6DE9CvCcf21JfC9Cq04RLHaG9EwDYiqLvvD
         vKWMHBhgRtG9L3QVge2Rpfoa93AKWaNRXTIfW8ZPMo2rvIPrW0yZRygLzxdET1mv0bFa
         xttQxL59G7LV9/VKdO57TWDqj4ICGR/V7uEs+jsogi/xTdca5X4EFCIJAyT34PpQU+qp
         FYYYGnKlAGeOp3xDvXoP/fRhNj1HcI0QDcIdwrrppJsluO21l3yJWw11fIIpitaDamp9
         OoeA==
X-Gm-Message-State: AGRZ1gJKPyZNtYHiyEI8TRDLyHZ4N+/3ut+5I9Rs/68nFXvFhay4SfYq
        g3oz9QMuphjYT0ACM7xMP9tXLlr8lp0=
X-Google-Smtp-Source: AJdET5fvZL+XozUPCRVvZPDGGzF5CU4ZMAl/p+JO33gc5ibfRcUgAJ+cMmA9ltkouG+ZSrOsSmojKA==
X-Received: by 2002:a1c:9c0a:: with SMTP id f10mr28307338wme.73.1543326840795;
        Tue, 27 Nov 2018 05:54:00 -0800 (PST)
Received: from glet ([185.197.228.4])
        by smtp.gmail.com with ESMTPSA id 142sm5571019wmw.27.2018.11.27.05.53.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 05:54:00 -0800 (PST)
Date:   Tue, 27 Nov 2018 14:53:57 +0100
From:   Andrea Gelmini <andrea.gelmini@gelma.net>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fix typos in docs
Message-ID: <20181127135357.GA21964@glet>
References: <20181127133707.20323-1-andrea.gelmini@gelma.net>
 <1d338499-6e05-3a1a-e964-ea4ecb1dbef5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1d338499-6e05-3a1a-e964-ea4ecb1dbef5@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 03:41:55PM +0200, Nikolay Borisov wrote:
> On 27.11.18 г. 15:37 ч., Andrea Gelmini wrote:
> 
> Wrong position of space, should be mailing list

Thanks a lot Nikolay for the review.

I'm going to send new version.

Thanks again,
Andrea
