Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbcCJN2F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 08:28:05 -0500
Date: Thu, 10 Mar 2016 14:27:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: Remove unnecessary variable devstart
 from cmd_device_scan()
Message-ID: <20160310132744.GG18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56E0AC1B.3020405@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56E0AC1B.3020405@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 10, 2016 at 08:04:59AM +0900, Satoru Takeuchi wrote:
> It's unnecessary since it's always 1.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> ---
> This patch can be applied to devel (commit b2bdd0da8969).
> ---
>  cmds-device.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/cmds-device.c b/cmds-device.c
> index cb470af..78d6535 100644
> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -246,7 +246,6 @@ static const char * const cmd_device_scan_usage[] = {
>  static int cmd_device_scan(int argc, char **argv)
>  {
>  	int i;
> -	int devstart = 1;
>  	int all = 0;
>  	int ret = 0;
> 
> @@ -282,7 +281,7 @@ static int cmd_device_scan(int argc, char **argv)
>  		goto out;
>  	}
> 
> -	for( i = devstart ; i < argc ; i++ ){
> +	for (i = 1; i < argc; i++) {

Actually it needs to be set to optind before the for cycle, otherwise:

  # btrfs device scan -- /dev/sda
  ERROR: not a block device: --
