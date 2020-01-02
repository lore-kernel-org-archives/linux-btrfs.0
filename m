Return-Path: <SRS0=UIME=2X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E6CC2D0DC
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 16:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5814020692
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 16:21:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="b0zR3HwX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgABQVM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 11:21:12 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:35747 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728678AbgABQVM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jan 2020 11:21:12 -0500
Received: by mail-qv1-f66.google.com with SMTP id u10so15108215qvi.2
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jan 2020 08:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7cb7VRoak0SUrJ5ehzck1G1wfwEqLR0OmtNuwD2MYCU=;
        b=b0zR3HwXBG2+qyhg0ky8rIBB8etkvz5YotXu/aWVaSjhsg/rvMiQcfloRDWazfrHYY
         CfmQfAFkfyA8b7BETtR6Qrvnf/53gsu+QzA2sREi6KMj4LdFr8mNpGlVmEKrGKs0H2fH
         FMR1Fb33SgFABljUWxyCEAF03+rrVu0Vgmj4U4F7f97WTrEaEzQHPokSscKL+ENMoJpS
         vBWcXflAhWAZ7YgnScaKK5dJ0bWG5WFvPnoiRUyhzIQS1bDetbh3VisD2FQhv50bxgf1
         bSsaF1miUl135t1ZBWPpCbBfGTuqf2VetaiCo/tmbM3k31WVtycaP2dNXoQ663q5fjFR
         YW0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7cb7VRoak0SUrJ5ehzck1G1wfwEqLR0OmtNuwD2MYCU=;
        b=Ke2DGunkkF+6JZMrD5d6i64g/sjMEWWpy7OgDDndAWJjO59UsYFbm6IJgJbDZhPZiz
         +lX7ASpwSEPhBLVKQxgRdotJ5rkudqm1/JTyCZmX97+ocnQZ3UOonVTCQSZy1CU8/ibV
         Q/fZH//jqIUi3j2cp9ClUEJFsWjSLX/eeqIcqSYDafpPed48FWAKxl1KidMGSctQ4v24
         jLmLhtfxl344PHqBWwdxa18u2OoQ24c1K04ZLVFbHYXe5EOwyL88EvZQmfuNi2HFzExs
         geTH/dxW9VCcz4a9ihIc3+bQlyRyniG+Zm1no4NOC7Q3Vj83k02APAvhyC6OZ76y8AJT
         Uj9g==
X-Gm-Message-State: APjAAAX2luD7KwQiqCaQcOR5lPNSNRrJECdaAwp1k/+0667K438KpYG2
        uv8h1W5D4uFzr97tpDsr5JamsFt3cgA4rQ==
X-Google-Smtp-Source: APXvYqzgSVP2S3lxFKEOOQtbCpaOFbrAvWjBVDYHwZnnx9OOBxTlvUI9DE3JfN2qTR+VgRt2jS0dkg==
X-Received: by 2002:a05:6214:1923:: with SMTP id es3mr65336830qvb.49.1577982071331;
        Thu, 02 Jan 2020 08:21:11 -0800 (PST)
Received: from ?IPv6:2620:10d:c0a8:1102:ce0:3629:8daa:1271? ([2620:10d:c091:480::be95])
        by smtp.gmail.com with ESMTPSA id d9sm16894705qth.34.2020.01.02.08.21.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2020 08:21:10 -0800 (PST)
Subject: Re: [PATCH] btrfs: remove unnecessary wrapper get_alloc_profile
To:     Johannes Thumshirn <jth@kernel.org>, David Sterba <dsterba@suse.cz>
Cc:     linux-btrfs@vger.kernel.org
References: <20200102161457.20216-1-jth@kernel.org>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <d4b78d84-a996-845a-1807-ecbf50cacaec@toxicpanda.com>
Date:   Thu, 2 Jan 2020 11:21:10 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200102161457.20216-1-jth@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 1/2/20 11:14 AM, Johannes Thumshirn wrote:
> btrfs_get_alloc_profile() is a simple wrapper over get_alloc_profile().
> The only difference is btrfs_get_alloc_profile() is visible to other
> functions in btrfs while get_alloc_profile() is static and thus only
> visible to functions in block-group.c.
> 
> Let's just fold get_alloc_profile() into btrfs_get_alloc_profile() to
> get rid of the unnecessary second function.
> 
> Signed-off-by: Johannes Thumshirn <jth@kernel.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
