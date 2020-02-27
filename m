Return-Path: <SRS0=+uyb=4P=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D34C11D3D
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Feb 2020 19:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF49A2468F
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Feb 2020 19:51:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="FhkTLe6S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730201AbgB0TvN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 14:51:13 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:35733 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbgB0TvN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Feb 2020 14:51:13 -0500
Received: by mail-qv1-f67.google.com with SMTP id u10so199048qvi.2
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2020 11:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rqOk8Tbe4bLNAhsykL44wC5pTzBzu5w2Y44y5EhJ9cA=;
        b=FhkTLe6SNDQgkzVIFu+6XM/H9bYXU1yn54u59yD1tatYRw/JV4vYCVDXrIqxIk52zv
         qjZ6kpEUXTS8oaI8MR/uEFOLgIFDmyinkknqXx24LFvrQ9Qgdc8i5uQXHWNkSDK9/j9h
         jgTzWNWsv+az9hEfZVcVROc/0LgHOyscXc3M2BYr0OUsgSssf9tRi74re0eZ+vKytnDk
         UKhsqvFcYDodqGqYqf1yS+D4FO6ozcsJmLJz2lC0kBKWmT/ixhdF8AJSbnsD+CpnQDys
         NRX3DpRZSZUajz23QHdj0stw5uiOOeShuDUt3oDD9eeVcmZImPd64OtO10d4dOGlYkq8
         tPKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rqOk8Tbe4bLNAhsykL44wC5pTzBzu5w2Y44y5EhJ9cA=;
        b=nhIXmIdILoqvnJo9EbvWnf5v10qqZHXsJ2lyBf8k2aiUsrb6dKRSD0NW2OZ544dvSy
         Pg1JTHJM40W/B1asHP0H1OOYxcY2IggSPm8tVlqQUMPDsLU/OfacB18DE6PzD2X0obRm
         dmYSbhN246aheT4oYGEGB3s//FMj8imwtO/K0mjcybt5ZqfabsCa9//wBEniyeDRQJUe
         3eVcSevXu/0s3xmaEDBede+fpYPcWy4nugfT54VLCOcC1r1iwBnv9O4y2Nc8LKhkcYMo
         iEgsgBgVc3iC8GX1MrvafFNT1DfPf7FLt2//DXbvJwpdpAPSvRzQ+lJbPz0zGWRtOp8z
         EqAQ==
X-Gm-Message-State: APjAAAVjCWTmKViGP1Tn1NsB0EN8ikTFDLlJwjH/vZPjjS+wKtOCr8be
        S0yhPVId6f0h3r58ABSFXqx0jn1H7s4=
X-Google-Smtp-Source: APXvYqw649nO8MTQWB0sW3iVYkdEDyz3F4EXlaVJRnYfIigBiTHYFKWAl7oMErIwWzW6L+bcJAQ8zQ==
X-Received: by 2002:a05:6214:1874:: with SMTP id eh20mr598361qvb.122.1582833071375;
        Thu, 27 Feb 2020 11:51:11 -0800 (PST)
Received: from [192.168.1.106] ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id h13sm3702841qtu.23.2020.02.27.11.51.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2020 11:51:10 -0800 (PST)
Subject: Re: [PATCH 3/3] btrfs: relocation: Remove the open-coded goto loop
 for breadth-first search
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20200224060200.31323-1-wqu@suse.com>
 <20200224060200.31323-4-wqu@suse.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <72797bb0-b20c-3e80-6a15-131e33c9bd26@toxicpanda.com>
Date:   Thu, 27 Feb 2020 14:51:09 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200224060200.31323-4-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2/24/20 1:02 AM, Qu Wenruo wrote:
> build_backref_tree() uses "goto again;" to implement a breadth-first
> search to build backref cache.
> 
> This patch will extract most of its work into a wrapper,
> handle_one_tree_block(), and use a while() loop to implement the same
> thing.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Do you have this in a tree somewhere that I can look at it?  I tried applying 
these but they don't apply cleanly to anything I have, and it's hard to review 
this one without seeing how the code ends up after your diff.  Thanks,

Josef
