Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06725C43219
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 16:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA59A208CA
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 16:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfDZQem (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:34:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:51428 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726005AbfDZQem (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 12:34:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C4035B022;
        Fri, 26 Apr 2019 16:34:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 86125DA8D1; Fri, 26 Apr 2019 18:35:43 +0200 (CEST)
Date:   Fri, 26 Apr 2019 18:35:42 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, guaneryu@gmail.com
Subject: Re: [PATCH v2] fstests: btrfs: try use forget to unregister device
Message-ID: <20190426163542.GW20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        guaneryu@gmail.com
References: <1552988980-25710-1-git-send-email-anand.jain@oracle.com>
 <20190402081946.24838-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402081946.24838-1-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 02, 2019 at 04:19:46PM +0800, Anand Jain wrote:
> Some btrfs test cases use btrfs module-reload to unregister devices in
> the btrfs kernel. The problem with the module-reload approach is, if test
> system contains btrfs as rootfs, then you can't run these test cases.
> 
> Patches [1] introduced btrfs forget feature which can unregister devices
> without the module-reload approach.
> 
>  [1]
>  btrfs-progs: device scan: add new option to forget one or all scanned devices
>  btrfs: introduce new ioctl to unregister a btrfs device
> 
> And this patch makes relevant changes in the fstests to use this new
> feature, when available.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v2:
>  Update change log.
>  Rename _require_btrfs_forget_if_not_fs_loadable() to _require_btrfs_forget_or_module_loadable()
>  Rename _btrfs_forget_if_not_fs_reload() to _btrfs_forget_or_module_reload()

Reviewed-by: David Sterba <dsterba@suse.com>

> +_require_btrfs_forget_or_module_loadable()
> +{
> +	_btrfs_supports_forget && return
> +
> +	_require_loadable_fs_module "btrfs"
> +}
> +
> +_btrfs_forget_or_module_reload()
> +{
> +	_btrfs_supports_forget && return
> +
> +	_reload_fs_module "btrfs"
> +}

The extra return mentioned in v1 is probably just a matter of coding
style so I don't mind as long as it works.
