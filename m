Return-Path: <SRS0=CxMI=WM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91359C3A59C
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Aug 2019 17:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 593F32077C
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Aug 2019 17:02:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="EkGR75wI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfHPRCa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 13:02:30 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42071 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfHPRCa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Aug 2019 13:02:30 -0400
Received: by mail-qt1-f196.google.com with SMTP id t12so6792160qtp.9
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2019 10:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Um3p2AKAAl3+IW8IhKwXz9CkZd31gOW/u/wMfZ7+OSk=;
        b=EkGR75wITFEASXBWVmMdhNZyOK4r0KnZcw6L8TvxEuNSfFdlgECiLJw/se0b4dH1j4
         RyxZOfEr1gssFGIyLRGSUuK8urAmkMaMQ/1VbvHQKB+nLDBeq7HaDjOD16e12iUoewWx
         vwe486ZFX9PYmflZ7kKmhvhzHpaKoqF051VP2zIsSs7zJkYs9MCRG3ZxvHFkfJuMgPLF
         38Ccm28EOGc4/HxvqFZmsB+eUz3QViCNBK3VDFlz8hTD0i0lfaE3uqRUypd429SOxty9
         f3BLrTrUnzxvOQLLeMhsCdxFpF0MPqCnExEtKX9DWxQL2JUs8tFByjTqnMG7Gw8NbUfB
         9CIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Um3p2AKAAl3+IW8IhKwXz9CkZd31gOW/u/wMfZ7+OSk=;
        b=boJ2A+6oCrKQKyFm6uEipC7BoV5002KvjeoLQgEgNj8hB9YtzXV1yasqgmGekR+HKQ
         bT04j6TUE9op094etYooBJW0qNGqWxOamQ6oBfoyA2ARCh5pmpok+kwg59T1jeecaWXQ
         WLjNPCZoL9n7ns+VBtqlmowkW2etcAPufvBxGjXsX7tJbDlqa7Buk/VwYx7bLgBQGBAF
         +cl4mcPmDcauwbTrqgMqj7LrabGy5PNw/fvi4sCTsIFKPWdYQFDBcSKr2kRrSUaOAeXj
         MAA2/DsU/sOGG3lJIohdrFR7FHNdatZbs7wMkq2ziY+169WEgOx8oo+EaU8aAuo05JJO
         XVgA==
X-Gm-Message-State: APjAAAXbsxcxuK65Hglm/BmUHA6KR10n1qcW4tOPHc6iaDU3BZTebnHw
        tNVolTZ9ZQnG5aOzE7DkkHlT4zJQKqNRrQ==
X-Google-Smtp-Source: APXvYqxzKjdz1MiRUTfi2bkiBJW8GwaZyJRDnvwGGrnfZya3arKT0KmxveI4pLn/qBmbIhhhxcnyrA==
X-Received: by 2002:a05:6214:13a1:: with SMTP id h1mr2437056qvz.190.1565974949129;
        Fri, 16 Aug 2019 10:02:29 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 131sm3324019qkn.7.2019.08.16.10.02.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 10:02:28 -0700 (PDT)
Date:   Fri, 16 Aug 2019 13:02:27 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH 4/5] fs: export rw_verify_area()
Message-ID: <20190816170227.74dq3rev6cbkoz5h@MacBook-Pro-91.local>
References: <cover.1565900769.git.osandov@fb.com>
 <0f80a1adaf1dfd1eec71cf937db76a1b0459a0bf.1565900769.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f80a1adaf1dfd1eec71cf937db76a1b0459a0bf.1565900769.git.osandov@fb.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 15, 2019 at 02:04:05PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> I'm adding a Btrfs ioctl to write compressed data, and rather than
> duplicating the checks in rw_verify_area(), let's just export it.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
