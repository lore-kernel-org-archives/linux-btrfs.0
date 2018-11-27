Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5129AC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12BF420663
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="a5Yy/u/w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12BF420663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbeK1Gxx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:53:53 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:41515 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbeK1Gxx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:53:53 -0500
Received: by mail-yw1-f66.google.com with SMTP id f65so9673740ywc.8
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 11:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=LxC/oucw+bhi0m8aLRATebuXGBwvyptJKsxGHhjAvRk=;
        b=a5Yy/u/wiCcejdtfrorvhB7TFB/SdCC8Ga9Bd9JLq6MfzJmJlzLJXHnnGfUkPvssfS
         Suo2fXEGf7WcQHwLVh56ktR13v+WBxTK84S8ex4iX7BjnJ6T4kKRapLSYYXBBVtCHSC7
         b8oemlwmLtK91JPa41lH3C0sDQTBGKCQgCSPPOmuMfBr2RCENrmn23gqWcwykwRJwaEZ
         9pb77OCPwiqtxnidURtxTcFDRaGoo+iN9pZx6ddaHggFF/YhOAF4PEEIeGW/cy+b5+P1
         iGHZY0K//fKpARAICpN83zxkDQzaVIoGMX/mhxYKm+OAR/XvgMvfPN2P0jr+KHoW/mEw
         2AvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=LxC/oucw+bhi0m8aLRATebuXGBwvyptJKsxGHhjAvRk=;
        b=FMuxzALFtjS7nOTxQhNiFnpSHAzVMvWf6Or0f6+m1qvno0JEfpGpYDK3KmKakLUlLP
         wzHYVzfmfNB6ppRJIFEEKggaoTZ07QlPNhkAlHgXLeXJwvk0wQScNueybvp6VoCLWwEM
         e9l60N/m62rlAtimDMxPoGbn43CrTIyUaLKjNGnB2bu9plFhL1jvxQ1+dHc76cn3j2iy
         pZTjgX+iHztHD+HW+J5xCSs+gKPLFcGhVAXzX72baSx/LyKx8GhmJCqeXq+WHqCp969x
         5jb4D0k02SDuqgfYt9gYSfxoHCjd4270qHdF4tLJ1164f+9bmJMkyp8BmPMG8NPV1626
         xyNA==
X-Gm-Message-State: AGRZ1gLklgs/175djhDHZ0GQPQm8UE+QIPeRImasTqv/CpqXXD9aOeY8
        ZPt1x11jI6fXRYdsqgNzU9qjfQ==
X-Google-Smtp-Source: AJdET5cfmj+RbhlGB18/UEY2ncw5pI2hMa0ZLBJWSTauZHdaL4thcqcMhqY9TzIwV5tKfP5vHH/b1g==
X-Received: by 2002:a81:a40d:: with SMTP id b13-v6mr35090387ywh.345.1543348493066;
        Tue, 27 Nov 2018 11:54:53 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:4c40])
        by smtp.gmail.com with ESMTPSA id j72-v6sm1459515ywj.60.2018.11.27.11.54.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Nov 2018 11:54:52 -0800 (PST)
Date:   Tue, 27 Nov 2018 14:54:51 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 2/3] btrfs: wakeup cleaner thread when adding delayed iput
Message-ID: <20181127195450.fjor2gewhp3hri56@macbook-pro-91.dhcp.thefacebook.com>
References: <20181121190922.25038-1-josef@toxicpanda.com>
 <20181121190922.25038-3-josef@toxicpanda.com>
 <4e8aad56-42e2-d666-c909-d5d058b799c9@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e8aad56-42e2-d666-c909-d5d058b799c9@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 10:26:15AM +0200, Nikolay Borisov wrote:
> 
> 
> On 21.11.18 г. 21:09 ч., Josef Bacik wrote:
> > The cleaner thread usually takes care of delayed iputs, with the
> > exception of the btrfs_end_transaction_throttle path.  The cleaner
> > thread only gets woken up every 30 seconds, so instead wake it up to do
> > it's work so that we can free up that space as quickly as possible.
> 
> Have you done any measurements how this affects the overall system. I
> suspect this introduces a lot of noise since now we are going to be
> doing a thread wakeup on every iput, does this give a chance to have
> nice, large batches of iputs that  the cost of wake up can be amortized
> across?

I ran the whole patchset with our A/B testing stuff and the patchset was a 5%
win overall, so I'm inclined to think it's fine.  Thanks,

Josef
