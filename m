Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49EBDC433FE
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Feb 2022 12:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240387AbiBYMBB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 07:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240379AbiBYMA6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Feb 2022 07:00:58 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3542757B1
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Feb 2022 04:00:26 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 07C041F383;
        Fri, 25 Feb 2022 12:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645790425; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRd2righax7VeoY8SbOW2pQ3PyJjCd4gRvaeQml6l3o=;
        b=sJtH+HFh4hl67xM8v7QK93X9B10smRDxFFxojlAMNSvZYUSb4wUo1MxZ0Rj0ojp+rnYd3D
        rTseTyY/ALA9guP+dcxL0q6TsLnd/6UVDw421oLprzm25FZQkjRAmeAbnZ3AEUHSjaU8g/
        tpP3eYonH7RgZkq9EUBKVVOnqNiRLIM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D047813BAE;
        Fri, 25 Feb 2022 12:00:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZxryL9jEGGKRIgAAMHmgww
        (envelope-from <nborisov@suse.com>); Fri, 25 Feb 2022 12:00:24 +0000
Message-ID: <31330cd5-fa32-4ec9-7eab-11659ecef9f8@suse.com>
Date:   Fri, 25 Feb 2022 14:00:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Seed device is broken, again.
Content-Language: en-US
To:     Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <88176dfc-2500-1e9c-bac0-5e293b2c0b5c@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
In-Reply-To: <88176dfc-2500-1e9c-bac0-5e293b2c0b5c@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 25.02.22 г. 12:08 ч., Qu Wenruo wrote:
> Hi,
> 
> The very basic seed device usage is broken again:
> 
>      mkfs.btrfs -f $dev1 > /dev/null
>      btrfstune -S 1 $dev1
>      mount $dev1 $mnt
>      btrfs dev add $dev2 $mnt
>      umount $mnt
> 
> 

This usage is tested by btrfs/161 no, so it should have been caught 
during testing of the feature that implemented the assert.
