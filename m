Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56258 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaGBBIc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 21:08:32 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id C8AE83EE0BB
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 10:08:31 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.nic.fujitsu.com [10.0.50.91])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id D0409AC0159
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 10:08:30 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 7FFE71DB8045
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 10:08:30 +0900 (JST)
Message-ID: <53B35B7F.1090703@jp.fujitsu.com>
Date: Wed, 2 Jul 2014 10:08:15 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/6 v5] Btrfs: add missing cleanup on sysfs init failure
References: <1398002808-11080-1-git-send-email-fdmanana@gmail.com> <1403524871-2131-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1403524871-2131-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/06/23 21:01), Filipe David Borba Manana wrote:
> If we failed during initialization of sysfs, we weren't unregistering the
> top level btrfs sysfs entry nor the debugfs stuff.
> Not unregistering the top level sysfs entry makes future attempts to reload
> the btrfs module impossible and the following is reported in dmesg:
> 
> [ 2246.451296] WARNING: CPU: 3 PID: 10999 at fs/sysfs/dir.c:486 sysfs_warn_dup+0x91/0xb0()
> [ 2246.451298] sysfs: cannot create duplicate filename '/fs/btrfs'
> [ 2246.451298] Modules linked in: btrfs(+) raid6_pq xor bnep rfcomm bluetooth binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc parport_pc parport psmouse serio_raw pcspkr evbug i2c_piix4 e1000 floppy [last unloaded: btrfs]
> [ 2246.451310] CPU: 3 PID: 10999 Comm: modprobe Tainted: G        W    3.13.0-fdm-btrfs-next-24+ #7
> [ 2246.451311] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [ 2246.451312]  0000000000000009 ffff8800d353fa08 ffffffff816f1da6 0000000000000410
> [ 2246.451314]  ffff8800d353fa58 ffff8800d353fa48 ffffffff8104a32c ffff88020821a290
> [ 2246.451316]  ffff88020821a290 ffff88020821a290 ffff8802148f0000 ffff8800d353fb80
> [ 2246.451318] Call Trace:
> [ 2246.451322]  [<ffffffff816f1da6>] dump_stack+0x4e/0x68
> [ 2246.451324]  [<ffffffff8104a32c>] warn_slowpath_common+0x8c/0xc0
> [ 2246.451325]  [<ffffffff8104a416>] warn_slowpath_fmt+0x46/0x50
> [ 2246.451328]  [<ffffffff81367dc5>] ? strlcat+0x65/0x90
> (....)
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
> 
> V1..V4: There's no v1, v2, v3 and v4. Bumped directly to v5 to make all patches
>      in the series have the same version.
> V5: Rebased against latest chris/integration branch.
> 
>   fs/btrfs/sysfs.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index df39458..06ad529 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -710,10 +710,18 @@ int btrfs_init_sysfs(void)
>   
>   	ret = btrfs_init_debugfs();
>   	if (ret)
> -		return ret;
> +		goto out1;
>   
>   	init_feature_attrs();
>   	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
> +	if (ret)
> +		goto out2;
> +
> +	return 0;
> +out2:
> +	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
> +out1:
> +	kset_unregister(btrfs_kset);
>   
>   	return ret;
>   }
> 

