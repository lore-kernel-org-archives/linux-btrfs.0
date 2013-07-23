Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:63102 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3GWHnh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 03:43:37 -0400
Message-ID: <51EE3427.4010901@giantdisaster.de>
Date: Tue, 23 Jul 2013 09:43:35 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] Btrfs: add missing mounting options in btrfs_show_options()
References: <51EE130A.7020101@cn.fujitsu.com>
In-Reply-To: <51EE130A.7020101@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 23 Jul 2013 13:22:18 +0800, Wang Shilong wrote:
> +    if (btrfs_test_opt(root, RECOVERY))
> +        seq_puts(seq, ",auto_recovery");

"recovery" without the "auto_".

