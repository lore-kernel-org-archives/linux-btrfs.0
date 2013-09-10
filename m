Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:49216 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab3IJHry (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 03:47:54 -0400
Received: by mail-lb0-f178.google.com with SMTP id z5so6010023lbh.9
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Sep 2013 00:47:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378780109-8591-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1378780109-8591-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Date: Tue, 10 Sep 2013 10:47:52 +0300
Message-ID: <CAOi1vP_dLDdR_oDC52D8CTutVRRg7E9OJsDs7P+839B==+9fjA@mail.gmail.com>
Subject: Re: [PATCH v2 18/20] Btrfs-progs: fix magic return value in cmds-balance.c
From: Ilya Dryomov <idryomov@gmail.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, sandeen@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 10, 2013 at 5:28 AM, Wang Shilong
<wangsl.fnst@cn.fujitsu.com> wrote:
> If there is no balance in progress, resume/pause/cancel
> will return 2. Usage or syntax errors will return 1.
> And 0 means operations return successfully.
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
> v1->v2:
>         Address comments from Ilya Dryomov.

Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
