Return-Path: <SRS0=dx4s=6G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B85C55189
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 08:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B77552070B
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 08:26:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="vviFJBff"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgDVI0z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 04:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725811AbgDVI0z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Apr 2020 04:26:55 -0400
X-Greylist: delayed 794 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Apr 2020 01:26:54 PDT
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9741C03C1A6;
        Wed, 22 Apr 2020 01:26:54 -0700 (PDT)
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 8FEE113F7AB;
        Wed, 22 Apr 2020 10:26:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1587544013; bh=R+5K8GvpfaB5fPFgBojTvqmfDAV0B1cruWUnLhw+XC8=;
        h=Date:From:To;
        b=vviFJBffMyN0U5oWHJ/3UgnliShhXQob5hhCaVPuFp0b6o0j2uaROio9MuW7N1OGk
         BP5NIWSUcacXWsYJFVKNu+Rpw0DeLsgvV3nqrCVmlkMuMesjP3oYNve8K1G7s0yp99
         oHhHk2K438wfNoa2EloE2qtaJI9dHy3RV0VMCpLI=
Date:   Wed, 22 Apr 2020 10:26:53 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH U-BOOT 03/26] fs: btrfs: Cross-port
 btrfs_read_dev_super() from btrfs-progs
Message-ID: <20200422102653.0dee168f@nic.cz>
In-Reply-To: <20200422065009.69392-4-wqu@suse.com>
References: <20200422065009.69392-1-wqu@suse.com>
        <20200422065009.69392-4-wqu@suse.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.101.4 at mail
X-Virus-Status: Clean
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 22 Apr 2020 14:49:46 +0800
Qu Wenruo <wqu@suse.com> wrote:

> +/* A simple wraper to for error() from btrfs-progs */
> +#define error(...) { printf(__VA_ARGS__); printf("\n"); }

Is this from btrfs-progs?
I don't like these macros much, I prefer to use static inline functions.

static inline void error(const char *fmt, ...)
{
	printf(fmt, __builtin_va_arg_pack());
	printf("\n");
}

Attribute for printf can be added to check printf specifiers:
  __attribute__((format (__printf__, 1, 2)))

It is possible that this won't compile when optimizations are disabled.
In that case more attributes are needed
  __always_inline __attribute__((__gnu_inline__))
These could be defined as a macro in include/linux/compiler-gcc.h
  #define __gnu_inline __always_inline __attribute__((__gnu_inline__))

Marek
