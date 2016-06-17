Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33417 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbcFQSCg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 14:02:36 -0400
Received: by mail-pf0-f179.google.com with SMTP id i123so29137366pfg.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 11:02:36 -0700 (PDT)
Date: Fri, 17 Jun 2016 11:02:34 -0700
From: Omar Sandoval <osandov@osandov.com>
To: weiyj_lk@163.com
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Omar Sandoval <osandov@fb.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix error return code in btrfs_init_test_fs()
Message-ID: <20160617180234.GE28716@vader.DHCP.thefacebook.com>
References: <1466184040-10721-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466184040-10721-1-git-send-email-weiyj_lk@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 17, 2016 at 05:20:40PM +0000, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the kern_mount() error handling
> case instead of 0(ret is set to 0 by register_filesystem), as done
> elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Reviewed-by: Omar Sandoval <osandov@fb.com>

-- 
Omar
