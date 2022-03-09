Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45748C433F5
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Mar 2022 11:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiCILtQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 06:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbiCILtL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2022 06:49:11 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B5D14A220
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Mar 2022 03:48:10 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6BD1221111;
        Wed,  9 Mar 2022 11:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646826489; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JtEfT2ah2F8YI6F5nGQKzSoAVnAtd4BTzIIONNWWGHc=;
        b=TrOAE1i7StEJKOQRdOD2ThoWybf4vIKAvwS373EMc40GB9ntVihV4NVSANbbWtO+4Zb7gn
        uH4dBYTflhSownoZ2R3MgvYHgn2TuvT7mcRdoktMnpd0GzT6wZmLu1DwjOrDsQQf5QcFDZ
        2fSJhHdphyJgnzOSHdO3f3+HPynMNDo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3231513D7A;
        Wed,  9 Mar 2022 11:48:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id g81VCfmTKGJKbgAAMHmgww
        (envelope-from <nborisov@suse.com>); Wed, 09 Mar 2022 11:48:09 +0000
Message-ID: <bb846d2a-26a2-9a8e-be5b-e7c6daf6ab61@suse.com>
Date:   Wed, 9 Mar 2022 13:48:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 04/13] btrfs-progs: convert: use cfg->leaf_data_size
Content-Language: en-US
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1645568701.git.josef@toxicpanda.com>
 <c0abc5a5a87e6e8f22d225185a0fd23cafe0325e.1645568701.git.josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
In-Reply-To: <c0abc5a5a87e6e8f22d225185a0fd23cafe0325e.1645568701.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 23.02.22 г. 0:26 ч., Josef Bacik wrote:
> The mkfs_config can hold the BTRFS_LEAF_DATA_SIZE, so calculate this at
> config creation time and then use that value throughout convert instead
> of calling __BTRFS_LEAF_DATA_SIZE.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

nit: IMO this patch should be squashed into the patch 02.
