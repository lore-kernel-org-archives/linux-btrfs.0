Return-Path: <SRS0=yR0V=2H=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2ED0C43603
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 19:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B21C021775
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 19:25:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="dBnq6619"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfLQTZk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 14:25:40 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36000 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbfLQTZk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Dec 2019 14:25:40 -0500
Received: by mail-qk1-f196.google.com with SMTP id a203so8230430qkc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2019 11:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+BHWFaTbiDPTOInGD7to0WQBWGeToevaH3Tu19eOi50=;
        b=dBnq6619BvR+WVQcs4ZCA92BvYK2E934EUFve7iL34F0ntl+1VLWZfw+8gWgx1glkf
         ojHeklP9+271Tp0XmpVEoBI6bh/3RbnzyMqePTP+hpcB9VONhT+TbIwfyfdjy1N6y+Dr
         2GIccsYjB0W6C6zZCZYj3jWPjKc8uKPxalwVUqALp15FuJY0yWDl35c608tFU2m0CWEa
         ovP6Gv8EBh29vHwXascYAj3maezrPOj1UCNboElV+CovO7fY0Xzncal0XDnuMZLxY65x
         Cjxx8ufbkEJjD2+tN7edLWZZ1LDFYCOWKu3JIHDVFcCT5TDBRQxtQGCleWZ+ONXCJXHe
         NzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+BHWFaTbiDPTOInGD7to0WQBWGeToevaH3Tu19eOi50=;
        b=RaMAL+9Lxv75OyBGclAzfczXhZQwzkXiV/35yQFCGuJAL67JR42aNlSxcINGObNL+p
         xgDofR6rCHrM1+nuHAVg3U3bm9d67OAe3VO+yvO7BBbvkQmJQER7SHHhoyk/FPRajr8n
         SJslCxHq2U4iEoY1wQ7LjEdXjb788X6SzzCAgslurXOYwurn5NNTkrySaA8wDo6xemNu
         6OqYmladyxCnPlL+XT+3t5jW6b4mot85ogegJKqbIEAgLHWvzTCr9VaKBTCrEtqlxRMH
         zx6+kuxtm9Cc8y6Oq2zLr2ZlIhypiFbBqKgHnUaQ6MjieAp5Ot2TkHcAc/grPwv3pZro
         fX3Q==
X-Gm-Message-State: APjAAAWzoHqjYUF1woYFnW8s0UC52ooSoxZYKqP+oFw6oZhIHltrxLd8
        tIK9RqQJHSTN9YvQpWZ6Jg17O2GzDhgdIg==
X-Google-Smtp-Source: APXvYqyMNLMGHmqB0KhVw5M2NU9LpkPJW/nKThlscidDsyKnfYWtrQNl5sqOBMAcTg+Kirpug0M0Gg==
X-Received: by 2002:a05:620a:1403:: with SMTP id d3mr6659065qkj.243.1576610739482;
        Tue, 17 Dec 2019 11:25:39 -0800 (PST)
Received: from ?IPv6:2620:10d:c0a8:1102:ce0:3629:8daa:1271? ([2620:10d:c091:480::4217])
        by smtp.gmail.com with ESMTPSA id o7sm7340049qkd.119.2019.12.17.11.25.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 11:25:38 -0800 (PST)
Subject: Re: [PATCH v6 11/28] btrfs: make unmirroed BGs readonly only if we
 have at least one writable BG
To:     Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Cc:     Chris Mason <clm@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        linux-fsdevel@vger.kernel.org
References: <20191213040915.3502922-1-naohiro.aota@wdc.com>
 <20191213040915.3502922-12-naohiro.aota@wdc.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <78769962-9094-3afc-f791-1b35030c67dc@toxicpanda.com>
Date:   Tue, 17 Dec 2019 14:25:37 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191213040915.3502922-12-naohiro.aota@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12/12/19 11:08 PM, Naohiro Aota wrote:
> If the btrfs volume has mirrored block groups, it unconditionally makes
> un-mirrored block groups read only. When we have mirrored block groups, but
> don't have writable block groups, this will drop all writable block groups.
> So, check if we have at least one writable mirrored block group before
> setting un-mirrored block groups read only.
> 
> This change is necessary to handle e.g. xfstests btrfs/124 case.
> 
> When we mount degraded RAID1 FS and write to it, and then re-mount with
> full device, the write pointers of corresponding zones of written block
> group differ. We mark such block group as "wp_broken" and make it read
> only. In this situation, we only have read only RAID1 block groups because
> of "wp_broken" and un-mirrored block groups are also marked read only,
> because we have RAID1 block groups. As a result, all the block groups are
> now read only, so that we cannot even start the rebalance to fix the
> situation.

I'm not sure I understand.  In degraded mode we're writing to just one mirror of 
a RAID1 block group, correct?  And this messes up the WP for the broken side, so 
it gets marked with wp_broken and thus RO.  How does this patch help?  The block 
groups are still marked RAID1 right?  Or are new block groups allocated with 
SINGLE or RAID0?  I'm confused.  Thanks,

Josef
