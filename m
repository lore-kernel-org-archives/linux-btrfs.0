Return-Path: <SRS0=EJVa=44=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D4CC0044D
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Mar 2020 17:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E14420737
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Mar 2020 17:52:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="PYOh21hA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgCKRwb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 13:52:31 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37766 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730587AbgCKRwb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Mar 2020 13:52:31 -0400
Received: by mail-qk1-f193.google.com with SMTP id y126so2964835qke.4
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2020 10:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=52WohA7V7aJR6uvZam0XwBM1q8F74DZhzxhdor8xX1Y=;
        b=PYOh21hA8w4oyTbtMwqT3/zlJzzFomwdR5UEd3hYj/jeHAJIvziCKDa72VSqOhIG9H
         bOA5up+CjAFJtJu99Cxzk8r4eIK19QHPi6flQLsHympDLC5U/3Gj/ux70DHLbYXtmTfl
         f8QCDEn8GZHQafrmHeWC4Hf533TfbUYolDBoKUmFlievEFn8q+DwRMtdzaytpKQHlJln
         1cWlgryYlpfJqGuM3Lsu1Xmk55/dtfBRouwmALVCw8v3z7td7MTU9ySzQ+niSbqZGatQ
         HFQVQSWIflwY8bux44JgFGugaWqITqLz/+EzbCuAJmlRRbU1Osh4vlu3kWl8XdkRxIt6
         WYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=52WohA7V7aJR6uvZam0XwBM1q8F74DZhzxhdor8xX1Y=;
        b=hZyB0Assl8lCCoRjvfl9gGwDlipEuH3n2+ZoiWl8nU5Va5TnSGHq0dgrG5a/mnblzP
         SakEOlo8tbmiZhS7kOfIkt5uvtkW3CfiH/gz2LdiVm5r2ifWFW6rU0laoLb8SYONlZ2e
         TGnbWZB66PCMQB5I5bXUR2lPFnHU+aKAujQkNrOOWu1aZZZYUIACQXda1i5GUsumoIXP
         1M7MR6WzCv6f+RzqmgWfoe5xnxQ/c3/CnjBOQE3k9rIc9Qk5kPtXCILeONMSvOW7iSCm
         1jjPUo0eSMXfijac7NDG5tbAbRY4n1jSYETJhydKLTkxZaF7ZhzhViFgLYgZ1/2BxJpj
         UIXg==
X-Gm-Message-State: ANhLgQ2B2cGndGvlSpsoc9/KoUTpCK8L7E1w+OhiFzpCDi51Zdc2yhND
        44qh7OymFqHKroijdel+rLLSIXZQd1A=
X-Google-Smtp-Source: ADFU+vvp+/0vydynGOR4N+hal8XmbJkyDtmwICAbZQQal1ZAyXCT+88Y5YfBlaISyq6y+Suq6vPEvg==
X-Received: by 2002:a37:b103:: with SMTP id a3mr3949680qkf.204.1583949149561;
        Wed, 11 Mar 2020 10:52:29 -0700 (PDT)
Received: from [192.168.1.106] ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id o16sm26087484qke.35.2020.03.11.10.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 10:52:28 -0700 (PDT)
Subject: Re: [PATCH] btrfs: Optimise space flushing machinery
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20200310090035.16676-1-nborisov@suse.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <e66667cb-7be0-9d26-f462-d6094b892cde@toxicpanda.com>
Date:   Wed, 11 Mar 2020 13:52:27 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200310090035.16676-1-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 3/10/20 5:00 AM, Nikolay Borisov wrote:
> Instead of iterating all pending tickets on the normal/priority list to
> sum their total size the cost can be amortized across ticket addition/
> removal. This turns O(n) + O(m) (where n is the size of the normal list
> and m of the priority list) into O(1). This will mostly have effect in workloads
> that experience heavy flushing.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>   fs/btrfs/space-info.c | 13 ++++++++-----
>   fs/btrfs/space-info.h |  4 ++++
>   2 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index 9cb511d8cd9d..316a724dc990 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -389,6 +389,8 @@ void btrfs_try_granting_tickets(struct btrfs_fs_info *fs_info,
>   							      space_info,
>   							      ticket->bytes);
>   			list_del_init(&ticket->list);
> +			ASSERT(space_info->reclaim_size >= ticket->bytes);
> +			space_info->reclaim_size -= ticket->bytes;
>   			ticket->bytes = 0;
>   			space_info->tickets_id++;
>   			wake_up(&ticket->wait);
> @@ -784,16 +786,15 @@ static inline u64
>   btrfs_calc_reclaim_metadata_size(struct btrfs_fs_info *fs_info,
>   				 struct btrfs_space_info *space_info)
>   {
> -	struct reserve_ticket *ticket;
>   	u64 used;
>   	u64 avail;
>   	u64 expected;
>   	u64 to_reclaim = 0;
> 
> -	list_for_each_entry(ticket, &space_info->tickets, list)
> -		to_reclaim += ticket->bytes;
> -	list_for_each_entry(ticket, &space_info->priority_tickets, list)
> -		to_reclaim += ticket->bytes;
> +	lockdep_assert_held(&space_info->lock);
> +
> +	if (space_info->reclaim_size)
> +		return space_info->reclaim_size;

This undoes the fix that I put up making sure we include any space we can no 
longer overcommit.  Thanks,

Josef
