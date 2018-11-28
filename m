Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDFFEC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 16:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B084B2081C
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 16:17:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f3LCSkV8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B084B2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gelma.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbeK2DT1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 22:19:27 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45124 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729064AbeK2DT0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 22:19:26 -0500
Received: by mail-lj1-f194.google.com with SMTP id s5-v6so23953707ljd.12
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 08:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vb1U3KBhW+5zf7pK08VJPOEaHcDGy3ZjKwRjTYsXDZ8=;
        b=f3LCSkV8FTinVe8DpejIA2TXrTAfnNQqwylIutxxGscl9dbSBfOE62YGHXP7XXT8C4
         BZR3cyaDKzRAwrfsJ0f5dQju2cyhVQCjulia6qXpmV6tlUWMpfNbi/1SeiXZUiyUvVJD
         Z7YIFydr9MHI3Se//bgufi8Xpi74vrHqI5Py40x6UpHQhk4WyaA/14Jz+emfppnFRrok
         WOj8G2qfFq1fpES5Q4gP+T2liX7tViEEgQEVD7pGRhGzsYSMgASj9ra3q7efobD2Zy8P
         Xb5ZQCr1SgrXWHaPtWRX7CsDR7KJaNN0vg5ngTodhjGkHPq3IekPKCHzAzsd8+GpPqZD
         Gp5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=vb1U3KBhW+5zf7pK08VJPOEaHcDGy3ZjKwRjTYsXDZ8=;
        b=d3wJ1cWsdUm5GSXFj8P1mzGkAEoUOpx2DZYhuyIytrnnXmnY1RcBgXbfBgUVFmgWJq
         qJS0I+cCst2ZaNeMdofRKK5wsub7ueYSiaoHEzgqA/UkzKEAMIvktrcmOY5x/OPCKaTC
         ELLVjP4P+IbO6FJhkGoK5e0wJhw9McZec1W0KSLWr1Y94Z5NjkLBk6jji3zSXzEeefI4
         RtdxUYi4NRxKQLgIKhLIwE0hSPsYJyX76S/uvj+SzPCK0cODovHPgNTURs8m0AYNDRg/
         3GOhjwv2KQG1d0GECe7v65JydU2N8OJ1txy/1AzyQPR8YdymZAj1PLVjGHd3DQfr/f21
         vdKw==
X-Gm-Message-State: AA+aEWaRloFoJ3su1OTyZn5PT7TU6ivXsTx3eF4wRQ7up7ieXxBXG48z
        ay1z69VPxYFCKB6916jnr5w=
X-Google-Smtp-Source: AFSGD/XwmXax0Ek7X7wuRikn9o9+GwJsKqbaen/jB/BQAKBOXerAFoD+gvpBM4HFCtd8rc4TX7tFVQ==
X-Received: by 2002:a2e:99d7:: with SMTP id l23-v6mr22345934ljj.165.1543421833675;
        Wed, 28 Nov 2018 08:17:13 -0800 (PST)
Received: from glet (anon-35-50.vpn.ipredator.se. [46.246.35.50])
        by smtp.gmail.com with ESMTPSA id p10-v6sm1209668ljg.19.2018.11.28.08.17.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Nov 2018 08:17:12 -0800 (PST)
Date:   Wed, 28 Nov 2018 17:17:09 +0100
From:   Andrea Gelmini <andrea.gelmini@gelma.net>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fix typos
Message-ID: <20181128161709.GA9917@glet>
References: <20181128110513.6079-1-andrea.gelmini@gelma.net>
 <20181128155619.GS2842@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128155619.GS2842@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 04:56:20PM +0100, David Sterba wrote:
> 
> Thanks, such patches are accepted once in a while when the amount of new
> typo fixes becomes noticeable.

About this patch (and the others sent to this m/l), I don't
care to have them committed with my name.

Feel free to copy/integrate/commit with your/someone else name.

It's just - probably - the best way to let the real devs to know
about the typos, but it's not valuable effort that must be
recognized.

So, use them as you prefer.

Thanks a lot for your work,
Gelma
