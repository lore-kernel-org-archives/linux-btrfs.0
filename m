Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:47088 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbcCIIYc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 03:24:32 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 95C0FAC0123
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Mar 2016 17:24:28 +0900 (JST)
Subject: Re: [PATCH] Fix broken 'device scan' arguments parsing
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>,
        linux-btrfs@vger.kernel.org
References: <1457486380-4051-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56DFDDB0.5090207@jp.fujitsu.com>
Date: Wed, 9 Mar 2016 17:24:16 +0900
MIME-Version: 1.0
In-Reply-To: <1457486380-4051-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/03/09 10:19, Yauhen Kharuzhy wrote:
> commit 52179e4fea41e55f31c92cd033a0b53a5107b4f4 'btrfs-progs: unify argc
> min/max checking' brokes 'btrfs device scan' command when no argument
> was given. Fix this.
> 
> Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
> ---
>   cmds-device.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cmds-device.c b/cmds-device.c
> index cb470af..94ffdc5 100644
> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -273,7 +273,7 @@ static int cmd_device_scan(int argc, char **argv)
>   	if (all && check_argc_max(argc - optind, 1))

It's better to the above line as follows.

========
	if (all && check_argc_exact(argc - optind, 0))
========

>   		usage(cmd_device_scan_usage);
>   
> -	if (all || argc - optind == 1) {
> +	if (all || argc - optind == 0) {
>   		printf("Scanning for Btrfs filesystems\n");
>   		ret = btrfs_scan_lblkid();
>   		error_on(ret, "error %d while scanning", ret);
> 

Here is the test result.

* v4.4.1

======================
# ./btrfs device scan
Scanning for Btrfs filesystems
# ./btrfs device scan -d
Scanning for Btrfs filesystems
# ./btrfs device scan -d foo
btrfs device scan: too many arguments
usage: btrfs device scan [(-d|--all-devices)|<device> [<device>...]]

    Scan devices for a btrfs filesystem

     -d|--all-devices (deprecated)

==========================

* devel branch with this patch.

==========================
# ./btrfs device scan
Scanning for Btrfs filesystems
# ./btrfs device scan -d
Scanning for Btrfs filesystems
# ./btrfs device scan -d foo
Scanning for Btrfs filesystems
===========================

* devel branch without this patch.

==================
# ./btrfs device scan
# ./btrfs device scan -d
Scanning for Btrfs filesystems
# ./btrfs device scan -d foo
Scanning for Btrfs filesystems
===================

* devel branch with this patch and my patch.

=========================
# ./btrfs device scan
Scanning for Btrfs filesystems
# ./btrfs device scan -d
Scanning for Btrfs filesystems
# ./btrfs device scan -d foo
btrfs device scan: too many arguments
usage: btrfs device scan [(-d|--all-devices)|<device> [<device>...]]

    Scan devices for a btrfs filesystem

     -d|--all-devices (deprecated)

===========================

Thanks,
Satoru
