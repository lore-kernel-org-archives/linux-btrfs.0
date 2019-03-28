Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D5ACC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 17:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1716E20823
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 17:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfC1Rto (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 13:49:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:56926 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726034AbfC1Rto (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 13:49:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 11AB3ABE1;
        Thu, 28 Mar 2019 17:49:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6C5D3DA911; Thu, 28 Mar 2019 18:50:49 +0100 (CET)
Date:   Thu, 28 Mar 2019 18:50:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs try use forget to unregister device
Message-ID: <20190328175047.GR29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <1552988980-25710-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552988980-25710-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 19, 2019 at 05:49:40PM +0800, Anand Jain wrote:
> btrfs module reload was introduced to unregister devices in the btrfs
> kernel module.
> 
> The problem with the module reload approach is that you can't run btrfs
> test cases 124, 125, 154 and 164 on the system with btrfs as root fs.
> 
> Patches [1] introduced btrfs forget feature which lets to cleanup the
> kernel device list without kernel module reload.
> 
>  [1]
>  btrfs-progs: add cli to forget one or all scanned devices

The subject lines was changed to "btrfs-progs: device scan: add new
option to forget one or all scanned devices"

>  btrfs: introduce new ioctl to unregister a btrfs device

> So this patch uses forget feature instead of kernel module reload, if
> the forget feature is available.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  common/btrfs    | 20 ++++++++++++++++++++
>  tests/btrfs/124 |  6 +++---
>  tests/btrfs/125 |  6 +++---
>  tests/btrfs/154 |  6 +++---
>  tests/btrfs/164 |  4 ++--
>  5 files changed, 31 insertions(+), 11 deletions(-)
> 
> diff --git a/common/btrfs b/common/btrfs
> index f6513c06f95f..e94e011db04e 100644
> --- a/common/btrfs
> +++ b/common/btrfs
> @@ -382,3 +382,23 @@ _scratch_btrfs_sectorsize()
>  	$BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV |\
>  		grep sectorsize | awk '{print $2}'
>  }
> +
> +_btrfs_supports_forget()
> +{
> +	$BTRFS_UTIL_PROG device scan --help | grep -wq forget && \
> +		$BTRFS_UTIL_PROG device scan --forget > /dev/null 2>&1

The second part actually unregisters all devices, is there some more
lightweight way to detect the support? Like providing a valid block
device but without btrfs. If the ioctl is supported, then it returns
-ENOENT and if not supported then -EOPNOTSUPP.

> +}
> +
> +_require_btrfs_forget_if_not_fs_loadable()

_require_btrfs_forget_or_module_loadable

We don't want to load the filesystem but the kernel module.

> +{
> +	_btrfs_supports_forget && return

Why is the 'return' here? If the first command succeeds, then &&
proceeds to return that does implicitli returns 0. So it's redundant, or
I'm missing something subtle here.

> +
> +	_require_loadable_fs_module "btrfs"
> +}
> +
> +_btrfs_forget_if_not_fs_reload()

Same naming

> +{
> +	_btrfs_supports_forget && return
> +
> +	_reload_fs_module "btrfs"
> +}
