Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33962 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbeIMLZW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 07:25:22 -0400
Subject: Re: [PATCH] btrfs-progs: Eliminate remaining uses of strerror(errno)
To: Rosen Penev <rosenp@gmail.com>, linux-btrfs@vger.kernel.org
References: <20180913005216.17485-1-rosenp@gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <8523769a-dc37-81aa-138a-4702a8c2d009@suse.com>
Date: Thu, 13 Sep 2018 09:17:17 +0300
MIME-Version: 1.0
In-Reply-To: <20180913005216.17485-1-rosenp@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.09.2018 03:52, Rosen Penev wrote:
> %m allows a smaller filesize. Useful on embedded systems.
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  build/Documentation/Makefile |  142 +++++
>  build/Makefile.inc           |   42 ++
>  build/config.h               |  139 +++++
>  build/config.log             |  822 ++++++++++++++++++++++++++
>  build/config.status          | 1059 ++++++++++++++++++++++++++++++++++
>  build/version.h              |   14 +
>  cmds-qgroup.c                |    3 +-
>  messages.h                   |    4 +-
>  mkfs/rootdir.c               |   47 +-
>  qgroup.c                     |    3 +-
>  10 files changed, 2243 insertions(+), 32 deletions(-)
>  create mode 100644 build/Documentation/Makefile
>  create mode 100644 build/Makefile.inc
>  create mode 100644 build/config.h
>  create mode 100644 build/config.log
>  create mode 100755 build/config.status
>  create mode 100644 build/version.h

You clearly need to resend with changes only to  the *.[ch] files
