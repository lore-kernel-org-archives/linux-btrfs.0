Return-Path: <SRS0=5HN8=ZA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A48EC5DF60
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Nov 2019 19:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C144620659
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Nov 2019 19:29:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="JvP4joK3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387417AbfKHT32 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 14:29:28 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45769 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729896AbfKHT31 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2019 14:29:27 -0500
Received: by mail-qk1-f196.google.com with SMTP id q70so6262591qke.12
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Nov 2019 11:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZaXwk9ZvgVjf561TUtFfdoLurEzZ/EBueVR5e31UGVg=;
        b=JvP4joK3/fxv1M0ISVYdIX/Ick9yoj1WDwmg8thcL7+K7J0Zafir72OW4f3UWgzkia
         8nDGyKBk7ywnWXBPgSz/YFK9cvgriYNUiwkZHPcoO5r6wKvoAiVpGcB+BW2VNIK7ppSJ
         LJMNervzdlJe4f8ODqLNRNfskGhhms69IuBPY8WQRBKNELUo3ch/jYUGe8LmxTDmnkdr
         DrrQN3gQWzFwUa30tuu/pt5Bb5UYNEAGJvj1hBfDBIxVQDPbJHBQ7/8WF0wwinZmL7RR
         VJWMCnZJ/HxamS9hs+kriYQm04sin8t7hpVGCtSwAUKoAvL0ng6H+iPPmMQPZ7Iqsuqj
         i42g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZaXwk9ZvgVjf561TUtFfdoLurEzZ/EBueVR5e31UGVg=;
        b=fnjJh5jFeZYbwL6gK2LTDsDOC50z+q289SeG+4vzoBFetMFf/bl67F19N/U8B1hRw+
         zUWpqJ43dvqtAjek4HxE7i+w2MHZ97pFjyjbm4J5g5Q3ru+Xe2xTRp7kSkb7r3yOCtwo
         JlNSjlAV5IBUhVjcfZ29LQEz3VpzNmJ0vgn5JVDOy428eiWYNnv2hwx6+BDbm9ZzkWXW
         yRIdynGLWSKGhCqnmpA+bEm7ZyYDyY/w1ugurPc2qcW7EN9Y261LlMddpIyIIICNjQnw
         TZ4j/uxio1bkOERZD9gl/qUZDHg5ufVfgHP1BahiR76Egmfndpv7fOuC+CZ3I/bQxTG+
         XAxQ==
X-Gm-Message-State: APjAAAVtPXVMGqdy5XpcRwUgDQw6d8eRaK1+l2QqeNs9EW8aecDRPgU6
        VOD/qf5Ix7y4zU6Yvm0waa1uDg==
X-Google-Smtp-Source: APXvYqxnh52w2GxmFUp7MgqMlguE2CvxNItnT33ChHMrexyp6idcPzFUyt1MIoOIljIJdjrz+rh1bw==
X-Received: by 2002:a37:84c1:: with SMTP id g184mr10739751qkd.309.1573241366685;
        Fri, 08 Nov 2019 11:29:26 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1852])
        by smtp.gmail.com with ESMTPSA id b2sm3850512qtc.21.2019.11.08.11.29.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 11:29:26 -0800 (PST)
Date:   Fri, 8 Nov 2019 14:29:24 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/22] btrfs: add discard sysfs directory
Message-ID: <20191108192923.fr4spbbn6uzkksxi@macbook-pro-91.dhcp.thefacebook.com>
References: <cover.1571865774.git.dennis@kernel.org>
 <ddd9245fc0653d1b10538a5db7cbd2143a32ae0a.1571865774.git.dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddd9245fc0653d1b10538a5db7cbd2143a32ae0a.1571865774.git.dennis@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 23, 2019 at 06:53:04PM -0400, Dennis Zhou wrote:
> Setup sysfs directory for discard stats + tunables.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
