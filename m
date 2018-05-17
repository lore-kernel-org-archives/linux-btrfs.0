Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56883 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751179AbeEQMC3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 08:02:29 -0400
Date: Thu, 17 May 2018 13:59:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] btrfs: balance: add args info during start and
 resume
Message-ID: <20180517115944.GH6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180516025128.9899-1-anand.jain@oracle.com>
 <20180516025128.9899-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180516025128.9899-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 10:51:27AM +0800, Anand Jain wrote:
> Balance args info is an important information to be reviewed for the
> system audit. So this patch adds it to the kernel log.
> 
> Example:
> 
> -> btrfs bal start -dprofiles='raid1|single',convert=raid5 -mprofiles='raid1|single',convert=raid5 /btrfs
> 
>  kernel: BTRFS info (device sdb): balance: start data profiles=raid1|single convert=raid5 metadata profiles=raid1|single convert=raid5 system profiles=raid1|single convert=raid5
> 
> -> btrfs bal start -dprofiles=raid5,convert=single -mprofiles='raid1|single',convert=raid5 --background /btrfs
> 
>  kernel: BTRFS info (device sdb): balance: start data profiles=raid5 convert=single metadata profiles=raid1|single convert=raid5 system profiles=raid1|single convert=raid5
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

The log message can be useful, however please avoid using unchecked
strcat and rewrite it without it if possible. You can find some
inspiration how to join several strings in describe_relocation().
