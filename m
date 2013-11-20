Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:39260 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab3KTWQN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 17:16:13 -0500
Received: by mail-ob0-f176.google.com with SMTP id va2so1198393obc.7
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 14:16:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <528D2E9F.6070101@suse.com>
References: <528D2E9F.6070101@suse.com>
Date: Wed, 20 Nov 2013 14:16:12 -0800
Message-ID: <CAGXu5jJDYQ9ZZ77=Y-ipLb8ogOdtKhDCEP+FhbvQ=PxMD3HHDg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix static checker warnings
From: Kees Cook <keescook@chromium.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 20, 2013 at 1:50 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> This patch fixes the following warnings:
> fs/btrfs/extent-tree.c:6201:12: sparse: symbol 'get_raid_name' was not declared. Should it be static?
> fs/btrfs/extent-tree.c:8430:9: error: format not a string literal and no format arguments [-Werror=format-security] get_raid_name(index));
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
