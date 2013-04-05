Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161741Ab3DEOfe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Apr 2013 10:35:34 -0400
Date: Fri, 5 Apr 2013 16:35:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH V3 1/2] Btrfs: improve the performance of the csums lookup
Message-ID: <20130405143532.GA9152@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5153FB01.9030506@cn.fujitsu.com>
 <515BF138.90309@cn.fujitsu.com>
 <20130404131204.GQ1876@localhost.localdomain>
 <515E7B58.7050904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <515E7B58.7050904@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 05, 2013 at 03:20:56PM +0800, Miao Xie wrote:
> It is very likely that there are several blocks in bio, it is very
> inefficient if we get their csums one by one. This patch improves
> this problem by getting the csums in batch.
> 
> According to the result of the following test, the execute time of
> __btrfs_lookup_bio_sums() is down by ~28%(300us -> 217us).
> 
>  # dd if=<mnt>/file of=/dev/null bs=1M count=1024
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> Changelog v2 -> v3:
> - address the problem that the logical offset of the pages in the same bio is
>   not contiguous.

Does not crash at 091 anymore (it's btrfs-next based on 3.9-rc5 + v3).

david
