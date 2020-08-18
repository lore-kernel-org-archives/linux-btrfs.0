Return-Path: <SRS0=WNKx=B4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0536C433E1
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 745942076E
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:20:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="SB+xhULN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgHRPUO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 11:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbgHRPTi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Aug 2020 11:19:38 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4527C061389
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2020 08:19:38 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id y11so9705208qvl.4
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2020 08:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ieRXm7HLTkh5kMWZvo/Y+ElHI04Cc2SiJOEDWUH8cRU=;
        b=SB+xhULNSFUb3Sivo2kU84vqkPvilVL/iGaUyrvIZCqID8mvr1/4qCHZYqpLADgbbY
         IKo9ysWit6vl5zIeLi0jqFALLGNZDKhhBHz8kFbcIKXzJ8jECCWVIZjhe0xZsr5yg0jf
         1huMI/6jIdm8SWn1X/z3KYcFh9KOgaZrIoyC8g/z7vBvPYp7BxVYhmiHOzOceOTRHzZq
         kue2n4rVAtS8AaqO+wMeUA246InCkYuKdkfoQCnlw9L+Zi5ZfyZc2oxTFXLyWZgmCC14
         U+izy0vXOfuCN64ffPSjzBo2RymXfaZ8XNOgcii2tx2798zYOzoymLnMO1B1TZ1DL6Sc
         Mo7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ieRXm7HLTkh5kMWZvo/Y+ElHI04Cc2SiJOEDWUH8cRU=;
        b=WmE7yCZGIEvV2tbXFYHY/PpwgKp/NoP49C8/UjQR9//7S31Wq9Dd8N7Nw7m6BKCFM5
         AN0rAg+jPw5sUx9STFxv61dS8InYD6U/VGGszeGRIKjucOi85kOmPTA7YIhLzWtUL15N
         mWWsz9rN/SqMv+TlegDa0BzDE7LuRPKNhxbfnxupaInuNncTj7Zy6HHwABa9JjPWNV4T
         d3P2jiLAXnio0XoqtC3z0Bumn5nAQGCFok6XaJ4cmvEFnx6bHYAetwPvBwVZGEbQyETx
         lvjZnCsn6s/kSkZYfgdHZVU9RovB1DvpyW5fjmnQH/ZcrvX8HCgl74j6teQCa0ev+ddV
         ogUA==
X-Gm-Message-State: AOAM533LMfA3OA7hul9FRVL7WHC1NFH6BnmvNdO5IxEugRVW+kC8mzxD
        935iNzS6SAqWDa5FMG6jwHURAF6u7+IfrB2v
X-Google-Smtp-Source: ABdhPJwqms6VkFvCLKPMwj2KJ0AM9txblqV3fUf249zjXLPMOzehpNsnikoROF8engNouGIEqvCZZw==
X-Received: by 2002:a0c:9ac5:: with SMTP id k5mr6897786qvf.112.1597763977439;
        Tue, 18 Aug 2020 08:19:37 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d9::1055? ([2620:10d:c091:480::1:66f8])
        by smtp.gmail.com with ESMTPSA id x57sm24506901qtc.61.2020.08.18.08.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 08:19:36 -0700 (PDT)
Subject: Re: [PATCH v2] btrfs: Switch seed device to list api
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20200715104850.19071-6-nborisov@suse.com>
 <20200716072533.32592-1-nborisov@suse.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <d16be45c-89df-c928-4d49-ea968e7e3927@toxicpanda.com>
Date:   Tue, 18 Aug 2020 11:19:35 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200716072533.32592-1-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 7/16/20 3:25 AM, Nikolay Borisov wrote:
> While this patch touches a bunch of files the conversion is
> straighforward. Instead of using the implicit linked list anchored at
> btrfs_fs_devices::seed the code is switched to using
> list_for_each_entry. Previous patches in the series already factored out
> code that processed both main and seed devices so in those cases
> the factored out functions are called on the main fs_devices and then
> on every seed dev inside list_for_each_entry.
> 
> Using list api also allows to simplify deletion from the seed dev list
> performed in btrfs_rm_device and btrfs_rm_dev_replace_free_srcdev by
> substituting a while() loop with a simple list_del_init.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef

