Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47580 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731293AbeGQMlw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 08:41:52 -0400
Date: Tue, 17 Jul 2018 14:09:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: =?iso-8859-1?Q?St=E9phane?= Lesimple <stephane_btrfs@lesimple.fr>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: check: enhanced progress indicator
Message-ID: <20180717120924.GW3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530732014-5449-1-git-send-email-stephane_btrfs@lesimple.fr>
 <1530732014-5449-3-git-send-email-stephane_btrfs@lesimple.fr>
 <4d1cf068-d8a0-f9f7-375c-dd4240eaf31b@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4d1cf068-d8a0-f9f7-375c-dd4240eaf31b@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 17, 2018 at 10:23:47AM +0900, Misono Tomohiro wrote:
> On 2018/07/05 4:20, Stéphane Lesimple wrote:
> > @@ -9806,16 +9839,26 @@ int cmd_check(int argc, char **argv)
> >  		error("errors found in csum tree");
> >  	err |= !!ret;
> >  
> > -	fprintf(stderr, "checking root refs\n");
> >  	/* For low memory mode, check_fs_roots_v2 handles root refs */
> > -	if (check_mode != CHECK_MODE_LOWMEM) {
> > +        if (check_mode != CHECK_MODE_LOWMEM) {
> > +		if (!ctx.progress_enabled)
> > +			fprintf(stderr, "[6/7] checking root refs\n");
> > +		else {
> > +			ctx.tp = TASK_ROOT_REFS;
> > +			task_start(ctx.info, &ctx.start_time, &ctx.item_count);
> > +		}
> > +
> >  		ret = check_root_refs(root, &root_cache);
> > +		task_stop(ctx.info);
> >  		err |= !!ret;
> >  		if (ret) {
> >  			error("errors found in root refs");
> >  			goto out;
> >  		}
> >  	}
> > +	else {
> > +		fprintf(stderr, "[6/7] checking root refs done with fs roots in lowmem mode, skipping\n");
> > +	}
> >  
> >  	while (repair && !list_empty(&root->fs_info->recow_ebs)) {
> >  		struct extent_buffer *eb;
> > @@ -9844,8 +9887,15 @@ int cmd_check(int argc, char **argv)
> >  	}
> >  
> >  	if (info->quota_enabled) {
> > -		fprintf(stderr, "checking quota groups\n");
> > +		if (!ctx.progress_enabled)
> > +			fprintf(stderr, "[7/7] checking quota groups\n");
> 
> 
> qgroup_set_item_count_ptr(&ctx.item_count) is needed here too. Otherwise
> quota check causes segfault without -p option.

Thanks, fixed as

--- a/check/main.c
+++ b/check/main.c
@@ -9969,12 +9969,12 @@ int cmd_check(int argc, char **argv)
        }
 
        if (info->quota_enabled) {
+               qgroup_set_item_count_ptr(&ctx.item_count);
                if (!ctx.progress_enabled) {
                        fprintf(stderr, "[7/7] checking quota groups\n");
                } else {
                        ctx.tp = TASK_QGROUPS;
                        task_start(ctx.info, &ctx.start_time, &ctx.item_count);
-                       qgroup_set_item_count_ptr(&ctx.item_count);
                }
                ret = qgroup_verify_all(info);
                task_stop(ctx.info);
