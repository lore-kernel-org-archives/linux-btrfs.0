Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46276C282C7
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 18:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1643A21848
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 18:02:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="JyXKYRm8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfA2SCc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 13:02:32 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40929 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbfA2SCc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 13:02:32 -0500
Received: by mail-qk1-f195.google.com with SMTP id y16so12060443qki.7
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2019 10:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eMp7sKwAaFwSP6v89lKsDzTYpGNcv1T4nmmX9aswxZ4=;
        b=JyXKYRm8Xej+AqTsX5vc8eTHCgd70ssAy+fE2uJqBWXNaCj8jRP8cWkwhmgGF0zrmN
         hTzKjb47Jaug5/9WR2j6/jw79WUV1wqXpKR0UdFhkX9r2k7eCfSw9lhMualxxMeQ91t+
         mQIlu7zPXIooPEpmxsKrQWB1t3OqqGcIAZcx12C78w6I0GqxWKVI74ZUSvH+BatF0IB2
         +zSl4D9B6RC0w7lCzAX+AG/2FmHyfrknxKVmFSwIPC0kQxD8a2uR3YWk4tYAl8d4J5vH
         bUbkqKJcHJn7DX/7JBIvew+7rKKPt0GmJEu0ikhr3dkqxXT+bTViJWGfjPDUY5ju6TjF
         dIxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eMp7sKwAaFwSP6v89lKsDzTYpGNcv1T4nmmX9aswxZ4=;
        b=m766VdOcAcYVIdu5djfHSsHj9VHxn3nU1/JbEpPRt3etYRMddJM21uJHcWbLp4nY16
         0BFw+5wh+ZIgEiye6jTeHL2eH9uq7+IPrWuCO9MYNUp+dgCdBzLI1s1R33m+lVNiFBh2
         BMyYDmrV3EKa+9tRxYggyquqa7QUcoMcBKbFnvDe8FTahZwqi25Wv+b5m/gxMvjyMVpT
         epZeZkjLngBvi4KZtd4KCH3BG8d9IA2lE9Y8SY39EHdKyYcuEN30uSgKX1RPQUBYkgtB
         u6f19Cp1OwvCqgo8tecPZxg3Ry0oFrkq3xpra6LE7BiJ6ox1+tPh+NpIEGNoW6rxnCpl
         xnPA==
X-Gm-Message-State: AJcUukeieHOD9VY7QpfROHXkpCfqoGBPYSoRxUx9z3y5qgNhmgIwgiAd
        m9DOhKchORjHuZggMKqkSYE1dA==
X-Google-Smtp-Source: ALg8bN6Pmm0tdmToC3h2t+GJJfbeWsbjmB04UJ8llofg0UlwwoRdXc9eZ633nKi5+hupw20qsUT6uQ==
X-Received: by 2002:a37:8443:: with SMTP id g64mr25053699qkd.334.1548784951414;
        Tue, 29 Jan 2019 10:02:31 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id a17sm72613232qth.93.2019.01.29.10.02.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 10:02:30 -0800 (PST)
Date:   Tue, 29 Jan 2019 13:02:29 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] btrfs: manage heuristic workspace as index 0
Message-ID: <20190129180228.vz2khgqaayhcnrxd@MacBook-Pro-91.local>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-4-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128212437.11597-4-dennis@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 28, 2019 at 04:24:29PM -0500, Dennis Zhou wrote:
> While the heuristic workspaces aren't really compression workspaces,
> they use the same interface for managing them. So rather than branching,
> let's just handle them once again as the index 0 compression type.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
