Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF2BC4320A
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 Aug 2021 08:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67FFD60FC3
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 Aug 2021 08:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbhHaITJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 04:19:09 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:35616 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240192AbhHaITH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Aug 2021 04:19:07 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7295C221A6;
        Tue, 31 Aug 2021 08:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630397891; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+8g7wxn/nH3v2euXhQlACzVlFDeftMHXUv8qEo/Dipw=;
        b=cT3/86M5AWqj4V3KCdArMb4SlEb2VILcsoqoSpW16luST6jvYRctOkevdzQRvUrheVkh9K
        pgm6OBzvVMU5Iy78vyN6o+QeiJTlUVwapHBixqkG9zmnO05zfsyWj4IWCzxiQmXiIe1MHt
        Nw+EfFRetSeC/fm4SumoAl6K2j6hX08=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 2819C13299;
        Tue, 31 Aug 2021 08:18:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id jKEkBsPlLWEFWQAAGKfGzw
        (envelope-from <nborisov@suse.com>); Tue, 31 Aug 2021 08:18:11 +0000
Subject: Re: [PATCH V5 1/2] btrfs: fix lockdep warning while mounting sprout
 fs
To:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.com
Cc:     l@damenly.su
References: <cover.1630370459.git.anand.jain@oracle.com>
 <215cb0c88d2b84557f8ec27e3f03c1c188df2935.1630370459.git.anand.jain@oracle.com>
From:   Nikolay Borisov <nborisov@suse.com>
Message-ID: <5c9c7e1e-7909-f9a7-6e4d-9265e1bd0d5b@suse.com>
Date:   Tue, 31 Aug 2021 11:18:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <215cb0c88d2b84557f8ec27e3f03c1c188df2935.1630370459.git.anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 31.08.21 г. 4:21, Anand Jain wrote:
> Following test case reproduces lockdep warning.
> 
>  Test case:
> 
>  $ mkfs.btrfs -f <dev1>
>  $ btrfstune -S 1 <dev1>
>  $ mount <dev1> <mnt>
>  $ btrfs device add <dev2> <mnt> -f
>  $ umount <mnt>
>  $ mount <dev2> <mnt>
>  $ umount <mnt>
> 
> The warning claims a possible ABBA deadlock between the threads initiated by
> [#1] btrfs device add and [#0] the mount.
> 

Send this as an xfstest

<snip>
