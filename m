Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A112C64EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 18:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 244952084D
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 18:08:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="d/oFjVip"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 244952084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbeJEBCn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 21:02:43 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34679 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbeJEBCn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2018 21:02:43 -0400
Received: by mail-pf1-f196.google.com with SMTP id k19-v6so3784502pfi.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Oct 2018 11:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I/Rpu0uoUeS+a2QbJ7PwmzAM0cmr5UepqQVZG70jfzg=;
        b=d/oFjVipxORM3G+YskQk47ztl+S7Bqcd6Wo0kvDK0BriCQOYkfLLYXcVH2npkT80e/
         fMro2LRN+csqBUzUoxPySC4DEAQiVhfvZIUMCSV+IDeNZ7urKGc2sPqxPAeRvk4b/S2Y
         pQ2ylEfTMi5Al04N6KFS0qYz3+3m3+mcCP/j43IJu/c2wbNcSTorXPS4s0ZNKKVANAUE
         E9AbRgZq1GTLmygN24VJ+fQPW2ciTXk34UqMdXbrtoKS9VHaFAZOtzA9K9STtqaO9+e+
         EjM3Pyr+i8uH9yMBSyYKUv9fwCjPqeqBDJK873/DwV1F7neLxpzys6gyr0SgqpjN21Nf
         uDNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=I/Rpu0uoUeS+a2QbJ7PwmzAM0cmr5UepqQVZG70jfzg=;
        b=SUH9Y12OXMTddwNfFhU4LAM0bb2+JydyR3K9bwAaIKavCOC2qMwURqGPHl6+iIDGQE
         DQC0P8DeFtg4hCaY2SWejlPRv0mgNkZC+OPPu7UgT2uq7gX2t3I9LmUxV8IS2z6uD+3a
         M1wo5kjYvOBdm8zu15UgnAVU3f8fyhCH/mnCiNw3+WHjj5wSLswOZXvxghW49HmSrdtA
         dfnXN7gH3XoeFaHidYk1ngsrLvX71fBl54M5WeTvNpJBmRBvKZ7INfYc+hm2dU9KmgxJ
         zut6x13xiS5/vUxoGwpyq1so0icsliw7d6mdf3qpuUyPKrTluMDmrLvbCZOs/b/vtq2N
         JyOg==
X-Gm-Message-State: ABuFfojOmud27xlcmoRmrerVHEibl2AMrRHivwWjeqNQTjLuv1scQoOs
        ftF4+Hson2zjpjt8lmVrM44nuqvgROQ=
X-Google-Smtp-Source: ACcGV63Rwhlo0Jc7jfIIDpn9M22i8n4Bn57fYTZXsgXeN9lt4WGYXu3HBOLDk+MlAhlIvzwDNvvS4g==
X-Received: by 2002:a62:e511:: with SMTP id n17-v6mr7946914pff.210.1538676499003;
        Thu, 04 Oct 2018 11:08:19 -0700 (PDT)
Received: from vader ([2620:10d:c090:200::7:7e9a])
        by smtp.gmail.com with ESMTPSA id 74-v6sm8136938pfx.182.2018.10.04.11.08.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Oct 2018 11:08:18 -0700 (PDT)
Date:   Thu, 4 Oct 2018 11:08:17 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 04/10] btrfs-progs: Implement find_*_bit_le operations
Message-ID: <20181004180817.GD25437@vader>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
 <1538405181-25231-5-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538405181-25231-5-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 01, 2018 at 05:46:15PM +0300, Nikolay Borisov wrote:
> This commit introduces explicit little endian bit operations. The only
> difference with the existing bitops implementation is that bswap(32|64)
> is called when the _le versions are invoked on a big-endian machine.
> This is in preparation for adding free space tree conversion support.

I had to check, but it looks like these are also pulled from the kernel
source, so

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  kernel-lib/bitops.h | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 82 insertions(+)
