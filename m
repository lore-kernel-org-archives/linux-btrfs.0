Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:17970 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3GaQaj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 12:30:39 -0400
Message-ID: <51F93BAD.4030306@giantdisaster.de>
Date: Wed, 31 Jul 2013 18:30:37 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add dedup subcommand
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com> <1375285066-14173-7-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1375285066-14173-7-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 31 Jul 2013 23:37:46 +0800, Liu Bo wrote:
> This aims to add deduplication subcommand, 'btrfs dedup command <path>',
> ie. register/unregister'.
> 
> It can be used to enable or disable dedup support for a filesystem.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  Makefile     |    2 +-
>  btrfs.c      |    1 +
>  cmds-dedup.c |  101 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  commands.h   |    2 +
>  ctree.h      |    2 +
>  ioctl.h      |    5 +++
>  6 files changed, 112 insertions(+), 1 deletions(-)
>  create mode 100644 cmds-dedup.c

No manpage?

