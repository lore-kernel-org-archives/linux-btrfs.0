Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BFEFC10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 14:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1BD42146E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 14:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555339473;
	bh=eMSN+EAylcudexxo34mF+4UbIw22+4v3nzlNY0hE0jg=;
	h=References:In-Reply-To:From:Date:Subject:To:List-ID:From;
	b=gnh/W+BuPru3Vv/ixzzTHXw1TJtcxucuWM8q+b6wmVkjLLQs5VfTOKCiQtfK9gAVC
	 uiaGFhOAy78bR5qabtH03afo5ZDRasP8KxxeVcwI0CAeZUNvk1816ikKIlmSNzuqLl
	 x2yfwNmak8zRgkzLK/jbBH0DpPVZ4MuwpnvgndrE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfDOOoc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 10:44:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbfDOOob (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 10:44:31 -0400
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DA112146E
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 14:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555339471;
        bh=eMSN+EAylcudexxo34mF+4UbIw22+4v3nzlNY0hE0jg=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=yJ0wi7AYcK22fjSyBpzJULMUDzcIiDNhD837h/G+MSOgDb5hADKt9VhH60h0eV3HQ
         6YZ5/b5b5FURWGe8lEy/KsgLQw/0TEInMmtrmSfxUHi6RhEwJmzyIzuUAglR31Zo5s
         K5ol/F48/e+JsjnvsTpDu2p9xp22ddQFqkuHvRjU=
Received: by mail-vk1-f175.google.com with SMTP id s63so3680839vkg.10
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 07:44:31 -0700 (PDT)
X-Gm-Message-State: APjAAAVlcJGvZGAQmxdoIqyEPV2SU83Be9XbH7mUxqGEGuok6gcc/1hw
        2s7W6r4me3ndMDz5Z3xnXwJJvTEaHIJ88Sot38w=
X-Google-Smtp-Source: APXvYqxezAvugBWSALgpget1KEsR0mPP84yP5t/85Bia9W/2QOU3FAUe0y4gLyj3OrOEhUhKVyRaMJi/j6NxsVvpCSo=
X-Received: by 2002:a1f:29c5:: with SMTP id p188mr40396497vkp.24.1555339470426;
 Mon, 15 Apr 2019 07:44:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190415082910.2073-1-fdmanana@kernel.org> <20190415143500.GI3476@twin.jikos.cz>
In-Reply-To: <20190415143500.GI3476@twin.jikos.cz>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 15 Apr 2019 14:44:19 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5edZnuhwSrV6V71UmYa2AY5PPhef4VTQ-dV6PLzF2jtA@mail.gmail.com>
Message-ID: <CAL3q7H5edZnuhwSrV6V71UmYa2AY5PPhef4VTQ-dV6PLzF2jtA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: allocate ulists in btrfs_check_shared() using GFP_KERNEL
To:     dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 15, 2019 at 3:33 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Mon, Apr 15, 2019 at 09:29:10AM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > As of commit bb739cf08e8f32 ("btrfs: btrfs_check_shared should manage its
> > own transaction") btrfs_check_shared() manages its own transaction, it
> > no longer receives a transaction handle as parameter. Since it is used
> > only in the fiemap path, the ulists it needs to use are allocated before
> > it grabs a transaction handle and we are not holding any locks that could
> > cause a deadlock in case reclaim happens during a memory allocation, we
> > can use the GFP_KERNEL flag to allocate the ulists instead of GFP_NOFS.
> > So do that switch.
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
>
> Reviewed-by: David Sterba <dsterba@suse.com>

Actually no, this isn't safe, drop it please.
An inode's range is locked, the allocations can trigger writeback for
that inode, and writepages() needs to lock the range as well.

Thanks.
