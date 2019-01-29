Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C59BDC169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 18:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9821B20857
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 18:17:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="oMpoF8oy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfA2SRr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 13:17:47 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43824 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbfA2SRr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 13:17:47 -0500
Received: by mail-qt1-f196.google.com with SMTP id i7so23291030qtj.10
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2019 10:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZEklhevKI3Gbhsb8btAczqDD1QOFHCflfX9NR1AtiuI=;
        b=oMpoF8oy79RuME85jCKezNXquwMeoHATz7FZ4NHIYYgps1343D6U2bnUqP0o0KH/Se
         C9uFwqnGrrnetRAEwQbrfx2ng8r3ea9h2qmUQSu6Sgdv6FPL+7mrWQU1hIpz4d+x7UQ2
         nHGvh2Qu33xo8Y3eMeVIlMWt0OTBvvewTuEyX1NX0CkklJHRB8mW7fZ6QYAxnGNsNASn
         KzI16qTifb5+qj1UM+xt1K22dQVVu149ptQE9BkIhEVK6NX1Bs0Z2b+C9NcJ/kxus55i
         TiIiKAJ9TXWsE70JlUQD7vhOj8jw3oX16/eZE3k5NW3wIvERtEY2DA8PGrviArJj+NCb
         z+mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZEklhevKI3Gbhsb8btAczqDD1QOFHCflfX9NR1AtiuI=;
        b=GKpGG8qo0UKlNOi60AU9ly5xNPFCpkibcQfCOMLKx//MwXYdUci2VZzKOu90r1HroD
         0p5Wlk/FouwD9zDq8t1RwqcL/dC2JMSMp+Wz5zsC5OUKhcQCI/1ZUFJ1Yaw+Cz/VzinX
         TnMgxeMhZLTlx5/kQyRbvdCFQu3Ss3t/YW4pw5TTVRqp9E6bYhrsO+GNVLxYWgDssRCD
         Hx9APrQI5ATxvRtAvu4sU9WIeZzUHMGjPTjjhqXx6cya5/XBFXT+JnL2X4RpVqjwskf1
         yo32Wht0InEHwmsHrWatV5/89FIiKtajWXuPlcHp3ycQnpLkjaa1HHaR9e9SEutKF+zN
         tkig==
X-Gm-Message-State: AJcUukc7FOsOQ+C1xxpjmjSgLpmywcKhQRx/MMQpdLN3f299LEjl6Kn9
        YbJAIRr0j5qdU0OaYDLjDPK+MA==
X-Google-Smtp-Source: ALg8bN4nnbZ9oOpkYdiiEUJ9B/YxJfGjNOrjQ8JujZijkSFXJV7mWjUyn3xhhANDE9X5P+89GI/HnQ==
X-Received: by 2002:a0c:f403:: with SMTP id h3mr25622844qvl.137.1548785866526;
        Tue, 29 Jan 2019 10:17:46 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id l4sm56869941qtf.22.2019.01.29.10.17.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 10:17:45 -0800 (PST)
Date:   Tue, 29 Jan 2019 13:17:44 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/11] btrfs: plumb level through the compression
 interface
Message-ID: <20190129181743.bap6zerlaup5ewaq@MacBook-Pro-91.local>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-9-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128212437.11597-9-dennis@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 28, 2019 at 04:24:34PM -0500, Dennis Zhou wrote:
> Zlib compression supports multiple levels, but doesn't require changing
> in how a workspace itself is created and managed. Zstd introduces a
> different memory requirement such that higher levels of compression
> require more memory. This requires changes in how the alloc()/get()
> methods work for zstd. This pach plumbs compression level through the
> interface as a parameter in preparation for zstd compression levels.
> This gives the compression types opportunity to create/manage based on
> the compression level.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
