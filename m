Return-Path: <SRS0=Lsqx=DM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E78DC4363A
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Oct 2020 13:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA0B2207BC
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Oct 2020 13:14:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="NyQ1V+zA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgJENO5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 09:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJENO5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2020 09:14:57 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D9AC0613CE
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2020 06:14:57 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id c62so11791166qke.1
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2020 06:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oWn1uI9+BHolv7wouG39QBnJV+w4A8ptyHvcKkepmcE=;
        b=NyQ1V+zADJCg3fRJfaCINQs12gGtUT9gvkI5ilnO0Ilratthu2+Lo9VU7O3BOstBak
         ENcpgR91iqM/eaXg+FBVBr7vCQ6Wr4Cgmn8RwQFmIYpScD/C4cNslKXigYTsWh45rF9y
         wiCFDeBmQxL7ChOdpgZb5+L3GqTMZcOXswUzPmuP3v/HbwM1CLofR5hqGF3vJNnGpYE+
         3KOQFPahRBLt21aSqRe5A8dV64usY8KDHTAa6/bEAvA/VhQhMMrFsDVBFuf6UcFBq+p1
         byHnjHY1HXtLBFmuwZiXpw1xHN0S8CJF4cJ7/+tceNXcDwxMYa9bdMgIZD5TC/HXRU92
         k+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oWn1uI9+BHolv7wouG39QBnJV+w4A8ptyHvcKkepmcE=;
        b=XHpuS28yfdUi/lmTHF7rTqMKEeEb9zQuwQsaq5srR0UQtAHBZhCybiiNiu7ryGMSsd
         n7yL8jhUzK9iPUTK+Tl2fKBvRuvENPMndtPPtdtHNchgiSFR63yR+d4IZGFv4rkU3gTo
         J4qmZhNicWUYQlaBagqveyqvcXVwjK4rk7AnFZg5DCV658jOSGq+YnCzb8H979ghQ4y+
         iVRjsgtalVRIy5kz2U4laeQfd+5vD49V8jyzcBD8goG4DPqd7jAxKfSdDpwhkMOfj2F3
         gEXx/Nin/Mr1UVLey6G4bqWi66gJRAnUmWEjh0h5Sr0epW0fKURYzXVQc6MwaaxQJhho
         iDBA==
X-Gm-Message-State: AOAM530ety+I1oMNyS7nrH7XxvpBmEsJ2AOKJT3XshC00sgzu5Pv+es6
        Jio/lG24ZfVIe0RPy/+nhsGDSQkhZLH7M1zK
X-Google-Smtp-Source: ABdhPJxrLrx3Ntc6ifzBsdpFAxz8uLEYA1STydmOOYH030X35MTFe/tCW2w+lJYuz+VnJHWxTEySKA==
X-Received: by 2002:a37:aa0a:: with SMTP id t10mr12256159qke.128.1601903696130;
        Mon, 05 Oct 2020 06:14:56 -0700 (PDT)
Received: from [192.168.1.45] (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id k52sm7710073qtc.56.2020.10.05.06.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 06:14:55 -0700 (PDT)
Subject: Re: [PATCH] btrfs: Increment i_size after dio write completes
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org
References: <20200921191930.e7phg6zpw4v4snin@fiona>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <41cc296f-5233-0eaa-62f5-295575836c93@toxicpanda.com>
Date:   Mon, 5 Oct 2020 09:14:54 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200921191930.e7phg6zpw4v4snin@fiona>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 9/21/20 3:19 PM, Goldwyn Rodrigues wrote:
> i_size is incremented when btrfs creates new extents during the start of
> a DIO write. If there is a failure until the endio, we will have a file
> with incremented filesize but no data. Increment the filesize after the
> successful completion of a DIO write.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 

We can't update the i_size outside of the i_mutex, this isn't ok.  Thanks,

Josef
