Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A633C4708C
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 May 2021 12:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA45E611BD
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 May 2021 12:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhE1Me4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 May 2021 08:34:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:58524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232310AbhE1Mez (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 May 2021 08:34:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1622205200;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IRwG23k8V1GRGhNhJ9XdKb8d9ILp4c7L9gkKH0LLWHQ=;
        b=QLYS+qOdRrvtISn+4TfwbDWOoA7CdhCBDBCnsUTTINEd+8sN+IdSFmwkAh7IdiDGUiE8Xb
        sC+mCdH9tNaxJFv49Ya0ao3rQurgVFC/MxIvpOohi7p8qrwIqr+GfuBKeqhbTfyR8CKsRE
        MADhSaXn5A/DSxutJPxeUiAoTrj5rjs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1622205200;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IRwG23k8V1GRGhNhJ9XdKb8d9ILp4c7L9gkKH0LLWHQ=;
        b=2C4uKU2K4jy4O/FVbRdtxMG4N0plX8YEutVG82dbYehH4qVoHdfzragZys6T+zWgouJVKg
        HRckiWWbPncQ29Cg==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EAC60AAA6;
        Fri, 28 May 2021 12:33:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DF7F2DA704; Fri, 28 May 2021 14:30:41 +0200 (CEST)
Date:   Fri, 28 May 2021 14:30:41 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/6] btrfs: introduce try-lock semantics for exclusive op
 start
Message-ID: <20210528123041.GA14136@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1621526221.git.dsterba@suse.com>
 <9a99c2204e431bc7a40bd1fb7c26ebb5fa741910.1621526221.git.dsterba@suse.com>
 <dc12e388-70b9-1349-1e20-85a7fc60d350@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc12e388-70b9-1349-1e20-85a7fc60d350@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, May 27, 2021 at 03:43:46PM +0800, Anand Jain wrote:
> On 21/05/2021 20:06, David Sterba wrote:
>   Nit:
>   This function implements a conditional lock. But the function name
>   misleads to some operation similar to spin_trylock() or
>   mutex_trylock(). How about btrfs_exclop_start_cond_lock() instead?

The semantics is same as spin_trylock so it's named like it. Try lock is
a conditional lock so I would not want to cause confusion by using
another naming scheme.

https://elixir.bootlin.com/linux/latest/source/include/linux/spinlock_api_smp.h#L86

static inline int __raw_spin_trylock(raw_spinlock_t *lock)
{
	preempt_disable();
	if (do_raw_spin_trylock(lock)) {
		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
		return 1;
	}
	preempt_enable();
	return 0;
}

bool btrfs_exclop_start_try_lock(struct btrfs_fs_info *fs_info,
                                enum btrfs_exclusive_operation type)
{
       spin_lock(&fs_info->super_lock);
       if (fs_info->exclusive_operation == type)
               return true;

       spin_unlock(&fs_info->super_lock);
       return false;
}

The code flow is the same.
