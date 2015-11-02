Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18218 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750775AbbKBBRk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Nov 2015 20:17:40 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
References: <e9288021adac2924ce1fdb637f61b9b924eff954.1446111097.git.zhaolei@cn.fujitsu.com> <2a8343f402a43c5332c7dcdbf8efa5aee9e49ae9.1446111097.git.zhaolei@cn.fujitsu.com> <20151030133554.GF13624@twin.jikos.cz>
In-Reply-To: <20151030133554.GF13624@twin.jikos.cz>
Subject: RE: [PATCH 5/6] btrfs-progs: free comparer_set in cmd_qgroup_show
Date: Mon, 2 Nov 2015 09:16:18 +0800
Message-ID: <028c01d1150c$1ab38ae0$501aa0a0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Friday, October 30, 2015 9:36 PM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH 5/6] btrfs-progs: free comparer_set in cmd_qgroup_show
> 
> On Thu, Oct 29, 2015 at 05:31:47PM +0800, Zhao Lei wrote:
> > comparer_set, which was allocated by malloc(), should be free before
> > function return.
> >
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > ---
> >  cmds-qgroup.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/cmds-qgroup.c b/cmds-qgroup.c index a64b716..f069d32
> > 100644
> > --- a/cmds-qgroup.c
> > +++ b/cmds-qgroup.c
> > @@ -290,7 +290,7 @@ static int cmd_qgroup_show(int argc, char **argv)
> >  	int filter_flag = 0;
> >  	unsigned unit_mode;
> >
> > -	struct btrfs_qgroup_comparer_set *comparer_set;
> > +	struct btrfs_qgroup_comparer_set *comparer_set = NULL;
> >  	struct btrfs_qgroup_filter_set *filter_set;
> >  	filter_set = btrfs_qgroup_alloc_filter_set();
> >  	comparer_set = btrfs_qgroup_alloc_comparer_set();
> > @@ -372,6 +372,8 @@ static int cmd_qgroup_show(int argc, char **argv)
> >  		fprintf(stderr, "ERROR: can't list qgroups: %s\n",
> >  				strerror(e));
> >
> > +	free(comparer_set);
> 
> Doh, coverity correctly found that comparer_set is freed inside
> btrfs_show_qgroups() a few lines above. Patch dropped.
> 
My bad.

This problem is find in my node by valgrind memckeck, maybe it
is not freed in some case, or a valgrind misreport.
I'll check it deeply.

Thanks
Zhaolei

> > +

