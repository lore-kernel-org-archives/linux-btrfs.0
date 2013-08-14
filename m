Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46844 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759943Ab3HNNdB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 09:33:01 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9C9FF7C0694
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 07:33:00 -0600 (MDT)
Date: Wed, 14 Aug 2013 09:32:58 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Anand Jain <Anand.Jain@oracle.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <dsterba@suse.cz>
Subject: Re: [PATCH 4/6] btrfs-progs: mkfs.c overwrites fd without
 appropriate close
Message-ID: <20130814133258.GB26269@localhost.localdomain>
References: <1374773730-29957-1-git-send-email-anand.jain@oracle.com>
 <1374773730-29957-5-git-send-email-anand.jain@oracle.com>
 <20130813191408.GI2150@localhost.localdomain>
 <520AE5A1.1010400@oracle.com>
 <520AF6B1.5020605@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <520AF6B1.5020605@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 14, 2013 at 11:17:05AM +0800, Anand Jain wrote:
> 
> 
> On 08/14/2013 10:04 AM, Anand Jain wrote:
> >
> >
> >On 08/14/2013 03:14 AM, Josef Bacik wrote:
> >>On Fri, Jul 26, 2013 at 01:35:28AM +0800, Anand Jain wrote:
> >>>Signed-off-by: Anand Jain <anand.jain@oracle.com>
> >>>---
> >>>  mkfs.c |    3 ++-
> >>>  1 files changed, 2 insertions(+), 1 deletions(-)
> >>>
> >>>diff --git a/mkfs.c b/mkfs.c
> >>>index 60f906c..66f558a 100644
> >>>--- a/mkfs.c
> >>>+++ b/mkfs.c
> >>>@@ -1570,6 +1570,8 @@ int main(int ac, char **av)
> >>>           * occur by the following processing.
> >>>           * (btrfs_register_one_device() fails if O_EXCL is on)
> >>>           */
> >>>+        if (fd > 0)
> >>>+            close(fd);
> >>>          fd = open(file, O_RDWR);
> >>>          if (fd < 0) {
> >>>              fprintf(stderr, "unable to open %s: %s\n", file,
> >>>@@ -1581,7 +1583,6 @@ int main(int ac, char **av)
> >>>          if (ret) {
> >>>              fprintf(stderr, "skipping duplicate device %s in FS\n",
> >>>                  file);
> >>>-            close(fd);
> >>>              continue;
> >>>          }
> >>>          ret = btrfs_prepare_device(fd, file, zero_end,
> >>>&dev_block_count,
> >>
> >>This breaks mkfs with multiple disks.
> >
> >  I can't believe as I have been playing with multiple disks
> >  quite a lot recently. let me dig more.
> 
>  Sorry my mistake.
> 
>  Indeed further down btrfs_add_to_fsid() stores fd. closing a
>  stored fd is not correct theoretically.
> 
>  Josef, Would be keen to know which xfstest caught this. ?
> 

It was btrfs/265, the one that does raid tests and such.

Josef
