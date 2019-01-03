Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E779AC43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E728208E3
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:22:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p2QJyqWq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbfACIWU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 03:22:20 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:40780 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfACIWU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2019 03:22:20 -0500
Received: by mail-lj1-f169.google.com with SMTP id n18-v6so29040037lji.7
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Jan 2019 00:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zYc4KfHFemVlpHqVQRbE9dRn2v6qCBXwl3mNPO6MIm4=;
        b=p2QJyqWqxu6wQR3rjX2ZJV8DVk8FXuUzFIzoREpPtF+OAF48lea5Rjh2sHD/5b1FlL
         a31Fya8tB1Li9E+kjnFqm2thln05WFMLm82gE5/33H6E8q3vYX+Y/O0jjdyVO+XNeVJw
         J+K1D63YDGqhl97dfBxDmfucLY23WzIjQaMtLJmFfbNg5q9hb7UxJ8/j+S8DvTUgfXxn
         ml+lhtMMaX7+04/rJd9w7mamxmbuGDMWiMtlO6lL4RlHfu4tkuR9/6GT3bzc45k8Hsjt
         uJEEdgIxwvJviEieegC0/6Fjk7qvtbrHcD3KriME/pVz2V7szvYHeZZ1UA4JlsgE53dG
         gclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zYc4KfHFemVlpHqVQRbE9dRn2v6qCBXwl3mNPO6MIm4=;
        b=qboB83voFKaJj9BPBcQqKU0mv9Vmh5oyuoaZuqlfDTetHkj6Az5oZe973ksIdL/CWY
         /T5eMEy2wZxc0UB6mmxwIml5x6XYWonbYW29veAUhoLdcpvnNku/ZmAgOZz8uCBgl7rN
         67g8aonmhbzIbaNrGhVbNlkgaJpqYc90mulJDkYYZNWcMxdhrpFPTtXVEmxn9tR2X/l4
         2wznEyP4oy/f7m8ZM0Aww5RvH3GxzpEg5E3+R4GNKUkeUodXQk5vSnylTqwvj0W+S52f
         9D5DyO2MxsyFdq4EsfFQln246OloEE0QWjvyyPYil1210CzPCCuKltUIjkL56V6qSD7p
         VwKQ==
X-Gm-Message-State: AA+aEWYxRInY6JG7BwvtMjLOeZ31Fbfdd/RyJ485oFNTbwxDeuhEtEJJ
        ura0SMDnLIwiG+LEArYE5PE=
X-Google-Smtp-Source: ALg8bN5Mfrb6WUIf3muHRkltn56VyV1SflgNue9RmVItkxLJ9tG20FPeMV1WNJsZt1aS1zSIxzDjzA==
X-Received: by 2002:a2e:8007:: with SMTP id j7-v6mr26534339ljg.50.1546503737753;
        Thu, 03 Jan 2019 00:22:17 -0800 (PST)
Received: from glet (anon-39-149.vpn.ipredator.se. [46.246.39.149])
        by smtp.gmail.com with ESMTPSA id r4sm10661841lfe.60.2019.01.03.00.22.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 03 Jan 2019 00:22:17 -0800 (PST)
Date:   Thu, 3 Jan 2019 09:22:13 +0100
From:   Andrea Gelmini <andrea.gelmini@gmail.com>
To:     Tomasz Chmielewski <tch@virtall.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        b11g <b11g@protonmail.com>
Subject: Re: BTRFS corruption: open_ctree failed
Message-ID: <20190103082213.GA74697@glet>
References: <155a0e09f60a0605802c459a6e119b36@virtall.com>
 <20190103072740.GA64625@glet>
 <b5df9ec049da6ecd9a4b3617d39d795f@virtall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5df9ec049da6ecd9a4b3617d39d795f@virtall.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 03, 2019 at 04:43:20PM +0900, Tomasz Chmielewski wrote:
> > And it's not a default/usual configuration.
> 
> Still - it is a default configuration for some distributions. I.e. Ubuntu
> "ppa" kernels[1] have this enabled by default (at least 4.19.x and 4.20.x).

a) he is not using Ubuntu;
b) I use this PPA;
c) if you look at the config, you see the default scheduler is not "none", also
   the mq is compiled as module and - anyway - on release with the bug you have to
   force the kernel to use it with boot parameter.

Ciao,
Gelma
