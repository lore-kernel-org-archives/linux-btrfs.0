Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 069E5C4332F
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Dec 2022 16:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiLTQjR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 11:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbiLTQiv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2022 11:38:51 -0500
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506261D657
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Dec 2022 08:38:38 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 6916382855;
        Tue, 20 Dec 2022 11:38:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1671554317; bh=JVtRHpJCun+KAV/MemJyWDjt7YZQfH5ABzDXRM+T0bQ=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=XK7WMAvkY3MNeSlHKlu3NQemCeX2cirDql0wNYicAMtf7jxZq7uQ9g0WvLr4b5cAu
         BjiqWhyZGbtWuhbfOd0daazrmYYEegkhj4Z0spXjdl/3cOLvPjYEi+wpU4+G0p/Uok
         gghkDWtmNSu46XV49i5vZQpu85omTa7dtY3rca32KZbEZ7C19BpEX1H6DUhMSsxtBN
         OZbo8pbF7b6oD47F9c8oebF4z6zzx2El3YvRm3tQtuf8WB6tUjXtTqoZxKQMgvSeCE
         8LhZflBWrQ1YUhUbetBLwghkrG/W5kBqw/parzjR1vf6U+RW4nyQYfUnKoviU8slhj
         T2ZHl6tfpD3kw==
Message-ID: <004329fe-89ac-6bb2-7d13-782183d7c1b3@dorminy.me>
Date:   Tue, 20 Dec 2022 11:38:36 -0500
MIME-Version: 1.0
Subject: Re: [PATCH] btrfs: fix fscrypt name leak after failure to join log
 transaction
Content-Language: en-US
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <c76a4f058227e32861e0afe1e1851137304a2169.1671534537.git.fdmanana@suse.com>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <c76a4f058227e32861e0afe1e1851137304a2169.1671534537.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12/20/22 06:13, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When logging a new name, we don't expect to fail joining a log transaction
> since we know at least one of the inodes was logged before in the current
> transaction. However if we fail for some unexpected reason, we end up not
> freeing the fscrypt name we previously allocated. So fix that by freeing
> the name in case we failed to join a log transaction.
> 
> Fixes: ab3c5c18e8fa ("btrfs: setup qstr from dentrys using fscrypt helper")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

I keep reexamining that change and still keep failing at finding missing 
frees until they're pointed out, so particular thanks.
