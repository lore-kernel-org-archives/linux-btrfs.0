Return-Path: <SRS0=Izu+=AR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21981C433E0
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Jul 2020 13:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00CAF20702
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Jul 2020 13:36:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="zQlM7jEZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgGFNgz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 09:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729148AbgGFNgy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2020 09:36:54 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3694DC061755
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Jul 2020 06:36:54 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id e12so28879957qtr.9
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jul 2020 06:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Ucl8wZ7igAOWKrZLLgx7QRADGSJ63BJc8+tfVjUH7Og=;
        b=zQlM7jEZ+Yk1lQYlVhq2XHiwCwqCjnQGPhPUVF9OACSRnaun0Y5tJ0TgsR/9URWo0k
         QtPfzznTnD9rncX3xWObvCO6RBloozFImQii+xQXcBygdTfkd9I4dMUs5/vfG4bVrpLt
         XOyXvVU248OVuVKrEhIi6ceCGH6TQbCbd7PSj6+ITL6zXdNiCSFK7BNTyIp+uL6NNGVa
         m+sW3/cwmbNLGtqJ5KoxOVy2xBred3f929fS9acUadvVyGwbSFqL7kFJvSTJAjZ7Upn1
         Qd7VmQmcc+L1c78/n0e5lg8sLQt833v4yaqmjVzZiBjIFAi4IxVRpNHHT/3OxKgIseEs
         YWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ucl8wZ7igAOWKrZLLgx7QRADGSJ63BJc8+tfVjUH7Og=;
        b=OJIo2c6UrRV5OKyoV6S84/A17IHg67/7ykNxy7iUR1ohzk9+NDBRAolOA0fdCZp7+s
         KBZZvo2LUQcf06wILWj698neExX9BKQpVpa9vwt3XoK8ZVHq2yGBWeXQ+LipVUaA7t2u
         yFaVTieaVcXeaZ8jKHvl3yJdPxvJSh9kQTBfrP8GwaJnEpUhxGymJSh5vkROJjU8v19u
         xS5b/NGMD476wE9hCAIyu4CD31VNvgmWEVR6+bM0bTO90F623Kw8rfQngigTDT4iboCu
         V1913gymqQVs5YPBUAyyuCBc21mkaMZDfJBvmNRBn7j/8ErfOzd+kzs2kDHm6r+0g8We
         fIRg==
X-Gm-Message-State: AOAM532JgyifWtjCsWgLGMuJspJjABf0bSNjtZDJ6a6W0kDiGHW+roAN
        k5b6ubM7qha4GWDAo6bP20mS0J1bT+vHOg==
X-Google-Smtp-Source: ABdhPJwWHaSyTb9ngujrja/7lxNAdV3+Vnf7v0N5mcUpxKbEjlp39lIC+cXv7rYvK63pPC8B1p/2ZA==
X-Received: by 2002:ac8:387c:: with SMTP id r57mr50884098qtb.144.1594042612681;
        Mon, 06 Jul 2020 06:36:52 -0700 (PDT)
Received: from [192.168.1.45] (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id 185sm18101784qkm.111.2020.07.06.06.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 06:36:52 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] btrfs: qgroup: Allow btrfs_qgroup_reserve_data()
 to revert EXTENT_QGROUP_RESERVED bits when it fails
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20200703061902.33350-1-wqu@suse.com>
 <20200703061902.33350-2-wqu@suse.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <f57050f6-60b6-72e8-c477-ee06f51b987e@toxicpanda.com>
Date:   Mon, 6 Jul 2020 09:36:51 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200703061902.33350-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 7/3/20 2:19 AM, Qu Wenruo wrote:
> [PROBLEM]
> Before this patch, when btrfs_qgroup_reserve_data() fails, we free all
> reserved space of the changeset.
> 
> This means the following call is not possible:
> 	ret = btrfs_qgroup_reserve_data();
> 	if (ret == -EDQUOT) {
> 		/* Do something to free some qgroup space */
> 		ret = btrfs_qgroup_reserve_data();
> 	}
> 
> As if the first btrfs_qgroup_reserve_data() fails, it will free all
> reserved qgroup space, so the next btrfs_qgroup_reserve_data() will
> always success, and can go beyond qgroup limit.
> 
> [CAUSE]
> This is caused by the fact that we didn't expect to call
> btrfs_qgroup_reserve_data() again after error.
> 
> Thus btrfs_qgroup_reserve_data() frees all its reserved space.
> 
> [FIX]
> This patch will implement a new function, qgroup_revert(), to iterate
> through the ulist nodes, to find any nodes in the failure range, and
> remove the EXTENT_QGROUP_RESERVED bits from the io_tree, and decrease
> the extent_changeset::bytes_changed, so that we can revert to previous
> status.
> 
> This allows later patches to retry btrfs_qgroup_reserve_data() if EDQUOT
> happens.
> 
> Suggested-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

I spent like 10 minutes reading all this trying to figure out why we need this 
new thing.  What you are saying is in the case of say fallocate, where you have 
something like

while (cur_len < total_len) {
	ret = btrfs_qgroup_reserve_data(&changeset);
	if (ret == -EDQUOT) {
		/* Flush */
		ret = btrfs_qgroup_reserve_data(&changeset);
	}
}

then doing the free that was in btrfs_qgroup_reserve_data() could free up space 
that we had already actually used.  So the problem isn't the flushing + 
subsequent retry, it's that we could have previous reservations on that 
changeset that _were_ successful, and previously we would free all of it which 
would allow us to go over the limit.  That's not clear at all from the commit 
message.  That being said the code is fine.  Thanks,

Josef
