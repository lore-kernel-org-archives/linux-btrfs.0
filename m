Return-Path: <SRS0=Rurt=5E=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC87C4332D
	for <linux-btrfs@archiver.kernel.org>; Thu, 19 Mar 2020 15:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F5612080C
	for <linux-btrfs@archiver.kernel.org>; Thu, 19 Mar 2020 15:42:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="ubQVwvX7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbgCSPmw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 19 Mar 2020 11:42:52 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45046 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbgCSPmw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Mar 2020 11:42:52 -0400
Received: by mail-qt1-f195.google.com with SMTP id y24so2148282qtv.11
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2020 08:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kCpC3wixYfRM4pbU369fHuJFKnniHgaHxNUvC3UFRSk=;
        b=ubQVwvX7017yzbuOMLsujGtlHB5C+R8Q8S+dO/p6ECBFVef3uCnaYcCaSD7S/HDoW+
         VhbrV/iZrUQKykK43iiQ2aYj6LL4uDQ0f9z6BMn8wyeapxMdSYpLm+3U3BKxhguwLAYx
         1Slgv1tQllfWBMF49R9cMa9RLZGwC5Fmkeaj2u9Pv+EQ45HqCZWoWzWFkJcgTuEQ18el
         Dtv1ZjgHPerXu8nh2BisgnhslA4sN7m+ETGOa1qJAzvUK7iO6V+h1H140UELR/UVM+Iv
         wKmUSUSsafVj0Z7f1DI6Mhit7bh5uLrE6YGLObz2O9yPhuYfFeMrm37hIin+sYo2xtlN
         kS5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kCpC3wixYfRM4pbU369fHuJFKnniHgaHxNUvC3UFRSk=;
        b=Ne0VnqZDK447owsFfO7ptc/OWopVMggQi8gY4nw92HcOyFLCJT2Bte+N8oeaDY4wn3
         jlOWlzehWoJPwi03k8xGTP5vy4xog6/cZMy6XT5mbHB7TheE3wpiUzuyY0fUaoRt54v8
         o6h2dcDnpGnPhD2CFA5L3vK/oSK+4F7t20M5OJGvuxVK3BRLN9nQEnYSOrwA1U96KDLA
         ZCvKcu8QUk1om6oqHhaejzOat8rdkoqPRWL7z/PHBd/9Az+tAcAqUBMlx9p50GVZJdYh
         5uPSTWZVLm1eeo5CbcmdYUlPVRTg13JQ8MB2eLuTRxDshjzIaxEHmDZfkkF8fG0Gy9T8
         WXhw==
X-Gm-Message-State: ANhLgQ2LkqWl1BOGTPB1aepYrpw1Of5VJRdJevMGvlF3ZmS9vy4tmNxL
        AFNM43AgZ5I3Fl5uNWc6tXPKN1LKQjM=
X-Google-Smtp-Source: ADFU+vs8rSpcEktpPwBOSoCZsEt5eqAgDP9Lfz8rBdm7Lo9SuYOfq0OR4o+1Iaeb7oLIEf6AK0NJqw==
X-Received: by 2002:ac8:3032:: with SMTP id f47mr3501163qte.273.1584632570519;
        Thu, 19 Mar 2020 08:42:50 -0700 (PDT)
Received: from [192.168.1.106] ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id w11sm1775611qti.54.2020.03.19.08.42.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 08:42:49 -0700 (PDT)
Subject: Re: [PATCH RFC 12/39] btrfs: relocation: Remove the open-coded goto
 loop for breadth-first search
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20200317081125.36289-1-wqu@suse.com>
 <20200317081125.36289-13-wqu@suse.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <27e22c9c-99cd-8b27-5be6-b8ad5b5657d1@toxicpanda.com>
Date:   Thu, 19 Mar 2020 11:42:48 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200317081125.36289-13-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 3/17/20 4:10 AM, Qu Wenruo wrote:
> build_backref_tree() uses "goto again;" to implement a breadth-first
> search to build backref cache.
> 
> This patch will extract most of its work into a wrapper,
> handle_one_tree_block(), and use a do {} while() loop to implement the same
> thing.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
