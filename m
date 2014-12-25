Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9030 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751668AbaLYHZ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Dec 2014 02:25:57 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBP7PSTU007613
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 15:25:28 +0800
Message-ID: <1419492235.1717.2.camel@localhost.localdomain>
Subject: Re: [PATCH 2/2] btrfs-progs: refine btrfs-debug-tree error prompt
 when a mount point given
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Date: Thu, 25 Dec 2014 15:23:55 +0800
In-Reply-To: <549BB36C.6030606@jp.fujitsu.com>
References: <1419470195-2889-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <1419470195-2889-2-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <549BB36C.6030606@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-12-25 at 15:49 +0900, Satoru Takeuchi wrote:
> On 2014/12/25 10:16, Gui Hecheng wrote:
> > Now, if exec:
> > 	# btrfs-debug-tree <mount_point>
> > it echos:
> > 	: Superblock bytenr is larger than device size
> > 
> > But it is quite misleading, because it is a valid btrfs.
> > In this case, we should tell the developer to provide a block device.
> > 
> > After apply:
> > 	: '<mount_point>' is not a block device
> > 	: 'usage: btrfs-debug-tree [options] device
> > 
> > Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> > ---
> >   btrfs-debug-tree.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> > 
> > diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
> > index e46500d..7f079a9 100644
> > --- a/btrfs-debug-tree.c
> > +++ b/btrfs-debug-tree.c
> > @@ -179,6 +179,12 @@ int main(int ac, char **av)
> >   	if (check_argc_exact(ac, 1))
> >   		print_usage();
> >   
> > +	ret = check_arg_type(av[optind]);
> > +	if (ret != BTRFS_ARG_BLKDEV) {
> > +		fprintf(stderr, "'%s' is not a block device\n", av[optind]);
> 
> fprintf(stderr, "ERROR: '%s' is ...)" is better since
> other error messages in btrfs-progs have this convention.

Yes, it is good to make it clear about the "ERROR", but since there is
no "ERROR" word throughout the source file, I think I would make all
error prompts to start with the "ERROR" word globally in the progs in
another patch.

Thanks,
Gui

> Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> Thanks,
> Satoru
> 
> > +		print_usage();
> > +	}
> > +
> >   	info = open_ctree_fs_info(av[optind], 0, 0, OPEN_CTREE_PARTIAL);
> >   	if (!info) {
> >   		fprintf(stderr, "unable to open %s\n", av[optind]);
> > 
> 


