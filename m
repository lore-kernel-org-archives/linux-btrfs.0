Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B981C433EF
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Jul 2022 14:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240304AbiGNODU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Jul 2022 10:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240348AbiGNODG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Jul 2022 10:03:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB73F58
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Jul 2022 07:02:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A53A634C9A;
        Thu, 14 Jul 2022 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657807333; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5XOMO+0toPzhWKxz4OeamK0d5ZZ7RAYGqcANNB5Gwik=;
        b=IGn+ZCUBv1kprdpan5LUiGD//KQ9rTLdH8Phdpw89v+Ram4ApGeKCXAtJR+vJf0BXfBF7r
        vU9VRiFJJoQHO98Zk7cWXwS74X1cqLn+2MFUHvS+yNwKKOrzZe3Zpf49KTosrTmpNYNvB2
        n4H86TuP6SEU0FEEg389j8rexRr+/Eg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4718B133A6;
        Thu, 14 Jul 2022 14:02:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NBl4DuUh0GK8KAAAMHmgww
        (envelope-from <nborisov@suse.com>); Thu, 14 Jul 2022 14:02:13 +0000
Message-ID: <471260f3-a48f-0eb2-a9aa-f74f8017fc98@suse.com>
Date:   Thu, 14 Jul 2022 17:02:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 08/11] btrfs: split submit_stripe_bio
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-btrfs@vger.kernel.org
References: <20220713061359.1980118-1-hch@lst.de>
 <20220713061359.1980118-9-hch@lst.de>
From:   Nikolay Borisov <nborisov@suse.com>
In-Reply-To: <20220713061359.1980118-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 13.07.22 г. 9:13 ч., Christoph Hellwig wrote:
> Split out a low-level btrfs_submit_dev_bio helper that just submits
> the bio without any cloning decisions or setting up the end I/O handler
> for future reuse by a different caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
