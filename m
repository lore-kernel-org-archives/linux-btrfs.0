Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B25C43219
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 03:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37FDF2063F
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 03:11:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u+Pqa9/d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfDZDLk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 23:11:40 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42623 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfDZDLk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 23:11:40 -0400
Received: by mail-pg1-f195.google.com with SMTP id p6so853357pgh.9;
        Thu, 25 Apr 2019 20:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9vhb+Xq5nLyg0zIK/YJPTr4pBo/L8lrGx/QU8To/L8s=;
        b=u+Pqa9/dLg1HG9xKoY8ilI3C6I4WoO7yTFF45VW2zrS8t9hgoHpDoDDR1dZpTHKb09
         LrLeCfZp6XdSOEjNWvJLnkEWfGF36SvAgWIQsxK5IB9cC48R7qQXOBNl53NO5fGDJ9Bm
         Xr1e+yN9LsKln2S/fdj3cmMJMzvkm5NkTU+WnRvGW80MtbaLemhsv7VkbSBSoXedcNvJ
         kTcg+xRUWyV1G5lzbKqUVzCCOSKvp8fqdis6f+RzTvv52GfAMvkoz8kXg3lYN7j3yMYU
         Wzdw5DN6vYyLItCw9F7uEpfvoTCZuIPGYUtxez8/3yyGKxdEvx8pN2kgNhV31LuXo0Ot
         Qo6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9vhb+Xq5nLyg0zIK/YJPTr4pBo/L8lrGx/QU8To/L8s=;
        b=kzH3jrO57JsrQn+GAiRsG3YRE1WnO5UlWV5vpEp6bYLOobtRQXXjuHG5z6MNubbfyh
         /C9xlbUD71NqHkYb/bJDLg5rJg0TJcL4nibnMi1MKqhX7E5l+QdebzKGq7G+JuFHhMlC
         AOkHtyE9L5aNsghQZjmCDBJ5M5Upd7C55x/4fB4lMTodZBIEfo12GbwlVKWc+w93Eru5
         JP+eZ8dRQJF6Lhp7HpL5Sm3yWGXWdynyEZW6gcQRTz4C7P0lZTOewenIJFo1NtU1jw0J
         QTTA1/UyNIR3YyBfF8Q0Zo8QyXwlLdWeDjxsJPNggJOtjEfUsCb5HnpSNVKOLxMru8K/
         8dOQ==
X-Gm-Message-State: APjAAAUILlygB78Pz6uYPNGk3HvcRikq3pCry1LC9NILi/FCOVuycejo
        37zVP9TJ252d9EM35nD7vwc=
X-Google-Smtp-Source: APXvYqyBHoI3tJtmja8zuvHpQQPqW2htQ+xKmaTGxX4GY3YO0QA/scHl99xj335zvI81XJAAY9O2qQ==
X-Received: by 2002:a62:305:: with SMTP id 5mr8662341pfd.65.1556248299750;
        Thu, 25 Apr 2019 20:11:39 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id g4sm32635022pfo.38.2019.04.25.20.11.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Apr 2019 20:11:38 -0700 (PDT)
Date:   Fri, 26 Apr 2019 11:11:33 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     fdmanana@kernel.org
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v2] btrfs: fix filtering of scratch device in test case
 048
Message-ID: <20190426031133.GC15846@desktop>
References: <20190425002457.28648-1-fdmanana@kernel.org>
 <20190425003709.28749-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425003709.28749-1-fdmanana@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 25, 2019 at 01:37:09AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The recent commit 4529b20e1aa8f9 ("btrfs/048: amend property validation
> cases"), does not properly filter the scratch device because the error
> messages are sent to stderr and not to stdout, and the pipe filter only
> gets input from the stdout of the btrfs utility. We need to redirect the
> stderr of the btrfs utility to its stdout.
> 
> Further, the golden output had the path "/mnt/scratch" hardcoded, instead
> of using SCRATCH_MNT. Fix that as well.
> 
> The test was failing on any setup where the scratch device is not mounted
> at "/mnt/scratch".
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Thanks for fixing it! Sorry that I missed the issues in review..

Eryu
