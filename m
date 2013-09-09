Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:42965 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab3IICvK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Sep 2013 22:51:10 -0400
Received: by mail-ob0-f169.google.com with SMTP id es8so5515726obc.0
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Sep 2013 19:51:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <522D3475.3010104@cn.fujitsu.com>
References: <CAFfJ-R6iw4ubyvcwtom9nZXjVpWfpzF+K+sJXKwQTWXiYcBBOA@mail.gmail.com>
 <522D3475.3010104@cn.fujitsu.com>
From: Dusty Mabe <dustymabe@gmail.com>
Date: Sun, 8 Sep 2013 22:50:49 -0400
Message-ID: <CAFfJ-R4Xxb+LjiWcx92rAiTWTxio+UY3h2FJ1BiWn3R9Vs67pQ@mail.gmail.com>
Subject: Re: BUG: qgroup scan started
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 8, 2013 at 10:37 PM, Wang Shilong
<wangsl.fnst@cn.fujitsu.com> wrote:
> Hello,
>
> This should have been fixed, the following patch should have fixed it.
>
> Btrfs: fix memory patcher through fs_info->qgroup_ulist
>
> https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?id=4373519db4dbca05341a60b28f6e159b106e4c4b
>

Thanks! I may wait for the fix to drift down to mainline before I pick
it up. I just wanted to help identify the problem if it was unknown.

Thanks again,
Dusty
