Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E28DCC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 16:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A42B1208E7
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 16:06:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A42B1208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733257AbeKOCJy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 21:09:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:53014 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726846AbeKOCJy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 21:09:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2D8F0ADF1;
        Wed, 14 Nov 2018 16:06:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4184BDACE4; Wed, 14 Nov 2018 17:05:48 +0100 (CET)
Date:   Wed, 14 Nov 2018 17:05:48 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix suspicious RCU usage warning in
 device_list_add
Message-ID: <20181114160547.GH24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20181114072456.4746-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114072456.4746-1-lufq.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 14, 2018 at 03:24:56PM +0800, Lu Fengqi wrote:
> =============================
> WARNING: suspicious RCU usage
> 4.20.0-rc2+ #23 Tainted: G           O
> -----------------------------
> fs/btrfs/volumes.c:886 suspicious rcu_dereference_check() usage!
> 
> Use btrfs_info_in_rcu instead of pr_info for the required lock/unlock of
> RCU string.
> 
> Fixes: 1f265fc6f58b ("btrfs: harden agaist duplicate fsid on scanned devices")

Thanks for the fix.

Please note that the patch is still in the devel queue (misc-next) so
the commit id is unstable, and such fixups get folded to the patch.

You may also reply to the original mail with patch, but sending a bare
code change without a full changelog is also fine if the original patch
was sent long time ago and the fixup could get lost.

> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 2186300bab91..6039ae5c549e 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -873,15 +873,15 @@ static noinline struct btrfs_device *device_list_add(const char *path,
>  			if (device->bdev != path_bdev) {
>  				bdput(path_bdev);
>  				mutex_unlock(&fs_devices->device_list_mutex);
> -				pr_warn(
> -		"BTRFS: duplicate device fsid:devid for %pU:%llu old:%s new:%s\n",
> +				btrfs_warn_in_rcu(device->fs_info,
> +			"duplicate device fsid:devid for %pU:%llu old:%s new:%s\n",

The trailing newline is appended by all btrfs_* message helpers, removed
in the commit.
