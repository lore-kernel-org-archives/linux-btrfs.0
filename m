Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC5E0C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 17:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AC1B206B6
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 17:12:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DHaeT51U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AC1B206B6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gelma.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbeK2EPM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 23:15:12 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:34237 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728997AbeK2EPM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 23:15:12 -0500
Received: by mail-pg1-f182.google.com with SMTP id 17so9784165pgg.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 09:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VAhRTpsnvLc5mYegc4z5nn3FiT9SYJB95RIOFzf2SNo=;
        b=DHaeT51UkAOB3aQQsaXfFL/m0JPWK9WoEckwtpNLd85qCj8HASeV3Eikf+viy52lE0
         jTEj1DxX8CT0OWEDLgem7vPUCj5aiAzA0Dp044WVHdz7SbBujSPU+WrW6Nkg9OOzzOjI
         Ovwr53AdZ2K/RyfVAyYdEAs43nFUOOIfVzYFX4cBkkNb88Ct01pJ67RdsCf/zOiYWm5d
         Uc67soClXooLtVQgN1INlvB555ZSmRcJ2wgsusRTx0FKDQ/mha6mdKAJ0Fh23/sHj+DB
         dnEg6W/FWfS4Rwz8w4FuizP7m1ElAIbU1t1eDG9zO73hjFxNn/qpsUlQxputlf38ETfl
         wZBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=VAhRTpsnvLc5mYegc4z5nn3FiT9SYJB95RIOFzf2SNo=;
        b=ZNy+j4mtSIXnVbheB0KR4vbKBOBomzn8PEnDke+o+s80DgOJwyurJK7bAZFe4ZfRoi
         uePBNKiAUBqb/m5fSWXcSjYLMJIKmGkwKNH5oH60ht3t1xSiCUZJhHDtznW24h0GIjGF
         MI1IlZtVy8CAaCByogJuUp1ua2RXpkWtmCQl1T5pJzbBSWYQF7Lg3MfE+I/ffaUGWHMI
         niMVLODhlv1mRAs4aRrxPLq516kkt3Z191GrlGrmToIuoOYlSiQgY4cT1UvvunuiIYfu
         Q/NIrHu+IVFGsDnCduf+fzSm2P7PJaT7CRGVYZTZAE2w/nNBydc/gNzYl+gZNhXZVTKG
         JLyg==
X-Gm-Message-State: AA+aEWZHiunQcOQ90y+Oh/n0G5SPSJ4FbnsbPuYPH/KPlsztGx7AkQBe
        QBcRyNwcXfKDZCIk216xt2I=
X-Google-Smtp-Source: AFSGD/UEwtY3F3CADJyHBN9yaYIA9EZvW+OW+H/tcqVEOLrJ23UObd4OdtRYioayWWiZX6M113ENGQ==
X-Received: by 2002:a62:5a03:: with SMTP id o3mr22476855pfb.19.1543425171205;
        Wed, 28 Nov 2018 09:12:51 -0800 (PST)
Received: from glet (anon-35-50.vpn.ipredator.se. [46.246.35.50])
        by smtp.gmail.com with ESMTPSA id n186sm9944147pfn.137.2018.11.28.09.12.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Nov 2018 09:12:50 -0800 (PST)
Date:   Wed, 28 Nov 2018 18:12:41 +0100
From:   Andrea Gelmini <andrea.gelmini@gelma.net>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fix typos
Message-ID: <20181128171237.GB9917@glet>
References: <20181128110513.6079-1-andrea.gelmini@gelma.net>
 <20181128155619.GS2842@twin.jikos.cz>
 <20181128161709.GA9917@glet>
 <20181128170247.GW2842@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128170247.GW2842@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 06:02:47PM +0100, David Sterba wrote:
> You've put your time to find and fix the typos so you deserve the
> credit. Because you sent them with the signed-off-by line I will use

Ok, David, thanks a lot.
So, I'm going to rework the patch with the various suggestion, and
then re-send it.

Thanks a lot,
Andrea
