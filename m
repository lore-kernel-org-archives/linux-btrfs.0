Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C3CDC169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 17:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40D6A21473
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 17:58:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="NFFMWMH7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbfA2R6L (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 12:58:11 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33105 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbfA2R6I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 12:58:08 -0500
Received: by mail-qk1-f196.google.com with SMTP id d15so12090147qkj.0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2019 09:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xmi7GMOCJFKQ9p0DB+iBObwqQ3C94ZKDr73FrxyQhpE=;
        b=NFFMWMH7CaJQeQCxZApkUa00L/1IdUvs+xhAIPYezPE1G19QYOynQsDC8CvzKM8dyR
         smdap8zODsGGs/Esnc/dMdfP5l8XSNV7rZHpaCmC50sJ251ZOG8RPPkV4eyyoFechqAl
         VfXxck7WY0ntndC60q0BEFaZdFblK6BZvMkbT0rwGKEzh5iQXOmmPOXfa5dHLatLxdnJ
         3iXhEKGQg9bAaCoRbhWbATo4NHpfOqkeuDHw11AkEae4G7fP2hcfCjDg2KeQJt6Mtr6j
         qdsp1usO4GODDI16guY/dFsTo7u/QPS7XLBNyraXmFfiOwnMhgT0j9smzirxDtHEC0Iv
         x5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xmi7GMOCJFKQ9p0DB+iBObwqQ3C94ZKDr73FrxyQhpE=;
        b=kzsCmPSaARmaXx/47BEEPecUwuhacJFulAyFIxXD/n4rkV30Rn0E5JphN2xzeCFvYq
         XQgSF0knJrpZUPqfbSQv0ywWOcySmlANJ/nGq1yCYxhS4rI3aRcz7+7SJg1WxcWfXNjN
         kmnIfvWXEZhk7iGG+XLvjHN0HBqd9/rfEQ0vDqHxJPiqxDPa1lZfCH0pLz2wEMCqLN0H
         A9Yp/Shxh7n1cZDaXfHpGStkqzqOZxUI1kcDutMw/gNsZqgsifc05T0xHp4+SnymVOAh
         97FDkpCOAyylpqBgQhfUwdE4aTmsKBiZlR2tqiVuIKmlq3pH6unCqnX2yd8zSn6X2oT7
         53Xg==
X-Gm-Message-State: AJcUukdbHZf/STKiU7yIQiKa1p+3CSduNT64qzl83Q2vj4JCHLycNkXM
        XWNilrnvDQZ1as7q+7Yg59WIqQ==
X-Google-Smtp-Source: ALg8bN7CjgKkA2ZNK+jI8kk8fU2+v1Ck0mxYhSNL7u6BrpX4wcnSxx+kG3okPNZU05jRqY/NvrLB9A==
X-Received: by 2002:a37:9b41:: with SMTP id d62mr24235018qke.215.1548784687290;
        Tue, 29 Jan 2019 09:58:07 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id a17sm72605094qth.93.2019.01.29.09.58.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 09:58:06 -0800 (PST)
Date:   Tue, 29 Jan 2019 12:58:05 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] btrfs: rename workspaces_list to workspace_manager
Message-ID: <20190129175804.izpyuekckkzuntj2@MacBook-Pro-91.local>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-3-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128212437.11597-3-dennis@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 28, 2019 at 04:24:28PM -0500, Dennis Zhou wrote:
> This is in preparation for zstd compression levels. As each level will
> require different sized workspaces, workspaces_list is no longer a
> really fitting name.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>
> ---

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
