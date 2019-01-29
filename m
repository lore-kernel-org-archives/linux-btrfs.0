Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10162C169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 18:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D013E2184D
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 18:04:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="KK/BmMBx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbfA2SEh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 13:04:37 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35963 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbfA2SEd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 13:04:33 -0500
Received: by mail-qt1-f193.google.com with SMTP id t13so23274542qtn.3
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2019 10:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cwEU7AT/ieVZmX0uniQzflMmYmVY27dwbxE28b4hY5o=;
        b=KK/BmMBxRo/7DcUUZt9q/dti8YEUhE3d/thibIQu8bV2rTQygTS0kCmrR7TQqsxjv/
         IXFC15AMSLKeHoTT0comMRxaiJcn30X9+AZoBupPNRZJVnUVJaALfpvmO8M+ltcUZyCw
         JSc397vrxvhsI4FOMNo7qHuhFjQZkBYpQddKTWCHcZzYD8hEaU8EL+P/MR5V+UkWYzAV
         crc0b41dGGHQkS7ZeMAHvD0y9y7ZCr+CJajvUEEIQU4p/tHVhb+TVpSN8UVxe2d5Fuhv
         gip8uEvcGU50VFxBIzpqUaW+670MWeDvrUefxWZ+Yg+ZYui0ltaTad6tHsLjNDcGcMBl
         VLZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cwEU7AT/ieVZmX0uniQzflMmYmVY27dwbxE28b4hY5o=;
        b=frk+bKdB3TigtlJ3JCL35UrAoGS3kFhfM5tOYX5PUDO+3MSJ1xtajpTHeTTEiKSKOI
         KPY3nVd13Bsyhjxb9MXYCgISiTXVpboQ/K+jjseCcqj4JVqJt+GNtke//3lm6XfkSHoD
         +CGFrw7X+usWiE8/bTsp1cVVPAC38Q1A/VDWp7gika/9HiyA1EgLnRchZufggE6RhUmP
         NAaxomPebKIAY0HHfJmlW1XsuHuOhnkJ4LDY4BwuOEuIwu/IIT/3OXLdMabDrCPXEJ5F
         Y9uaEj2gCEF+laWMWPE6ajy+xyVPomMYXLWF63pvovqz/YCQ1SsV4bc5qk80PbvZp37v
         EyeA==
X-Gm-Message-State: AJcUuke+MLYOhLsFZsZj90frz9g8neyhl2sWq6q37UnpCYNcdqfPUFzj
        yhGE0aZKM69uey9w0Ln+ZTiQdQ==
X-Google-Smtp-Source: ALg8bN6Zb6BV7j85r5PqzLkOoDoAArt1ZGj2iawq3cAEwna1LznWSuLXNoTHhTxh8cm29/d9GagqWQ==
X-Received: by 2002:a0c:afd1:: with SMTP id t17mr25139029qvc.93.1548785072068;
        Tue, 29 Jan 2019 10:04:32 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c7sm17856693qkj.72.2019.01.29.10.04.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 10:04:31 -0800 (PST)
Date:   Tue, 29 Jan 2019 13:04:30 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11] btrfs: add helper methods for workspace manager
 init and cleanup
Message-ID: <20190129180429.m7iwwrlnk2set6gl@MacBook-Pro-91.local>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-6-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128212437.11597-6-dennis@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 28, 2019 at 04:24:31PM -0500, Dennis Zhou wrote:
> Workspace manager init and cleanup code is open coded inside a for loop
> over the compression types. This forces each compression type to rely on
> the same workspace manager implementation. This patch creates helper
> methods that will be the generic implementation for btrfs workspace
> management.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
