Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A889C433F5
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 May 2022 08:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238131AbiEJIqw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 May 2022 04:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiEJIqs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 May 2022 04:46:48 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF1C2A28E4
        for <linux-btrfs@vger.kernel.org>; Tue, 10 May 2022 01:42:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 79A5F21BA4;
        Tue, 10 May 2022 08:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652172170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4fTVtaRo660tXkkXAAF9PiY2mye9NJj/QDC2EEJQtlQ=;
        b=pUp/sedruoEV7BKes8UXbHWis0A6cn96QkFm5dt8HhAOAhcXGuyE/c9AlpHvo5eB4N77Px
        oMPBfYTbkMLEk6cwPe6YKSKhgd/vfQXwX2inER2a4E6dZiT4RBcshako7okqmRURElQ1AW
        ugQ8k52Ch/Ck+Ynn8VfG7GXb5M3kEIg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 51A7713AC1;
        Tue, 10 May 2022 08:42:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id thw9EYolemKHGgAAMHmgww
        (envelope-from <nborisov@suse.com>); Tue, 10 May 2022 08:42:50 +0000
Message-ID: <af55ef8f-022b-01e6-1c25-d339b511a20b@suse.com>
Date:   Tue, 10 May 2022 11:42:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] btrfs: sysfs: export the balance paused state of
 exclusive operation
Content-Language: en-US
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20220503153525.22045-1-dsterba@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
In-Reply-To: <20220503153525.22045-1-dsterba@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3.05.22 г. 18:35 ч., David Sterba wrote:
> The new state allowing device addition with paused balance is not
> exported to user space so it can't recognize it and actually start the
> operation.
> 
> Fixes: efc0e69c2fea ("btrfs: introduce exclusive operation BALANCE_PAUSED state")
> CC: stable@vger.kernel.org # 5.17
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>   fs/btrfs/sysfs.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 366424222b4f..92a1fa8e3da6 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -957,6 +957,9 @@ static ssize_t btrfs_exclusive_operation_show(struct kobject *kobj,
>   		case BTRFS_EXCLOP_BALANCE:
>   			str = "balance\n";
>   			break;
> +		case BTRFS_EXCLOP_BALANCE_PAUSED:
> +			str = "balance paused\n";
> +			break;
>   		case BTRFS_EXCLOP_DEV_ADD:
>   			str = "device add\n";
>   			break;
