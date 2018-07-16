Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54358 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728833AbeGPRXu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 13:23:50 -0400
Date: Mon, 16 Jul 2018 18:55:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: =?iso-8859-1?Q?St=E9phane?= Lesimple <stephane_btrfs@lesimple.fr>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: check: enhanced progress indicator
Message-ID: <20180716165526.GS3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530732014-5449-1-git-send-email-stephane_btrfs@lesimple.fr>
 <1530732014-5449-3-git-send-email-stephane_btrfs@lesimple.fr>
 <3b66b23f-1998-e7f1-24f9-cdc8cab51c7d@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <3b66b23f-1998-e7f1-24f9-cdc8cab51c7d@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 11, 2018 at 01:18:55PM +0800, Qu Wenruo wrote:
> On 2018年07月05日 03:20, Stéphane Lesimple wrote:
> > We reuse the task_position enum and task_ctx struct of the original progress
> > indicator, adding more values and fields for our needs.
> > 
> > Then add hooks in all steps of the check to properly record progress.
> > 
> > Signed-off-by: Stéphane Lesimple <stephane_btrfs@lesimple.fr>
> 
> Looks pretty good.
> 
> Just some small nitpicks related to code style.

The coding style rules need to be more relaxed for one-time or
infrequent contributors so we don't scare them away.

I go through such patches line by line and fix where needed but it's ok
to point them out so I don't miss something.

> > @@ -173,28 +161,48 @@ static int compare_extent_backref(struct rb_node *node1, struct rb_node *node2)
> >  		return compare_tree_backref(node1, node2);
> >  }
> >  
> > +static void print_status_check_line(void *p)
> > +{
> > +	struct task_ctx *priv = p;
> > +	char *task_position_string[] = {
> > +		"[1/7] checking root items                     ",
> > +		"[2/7] checking extents                        ",
> > +		is_free_space_tree ?
> > +			"[3/7] checking free space tree                ":
> 
> The extra intent makes it a little hard to align the output.
> 
> What about using something like below to format the string?
> "[%d/%d] %-20s"
> 
> And this makes it more flex since lowmem and original mode has different
> progress number (lowmem doesn't need to check root refs separately).

I've kept it as is only did minor updates so it looks visually more
compact. If you have further ideas how to clean up the code, feel free
to send patches.

> 
> > +			"[3/7] checking free space cache               ",
> > +		"[4/7] checking fs roots                       ",
> > +		check_data_csum ?
> > +			"[5/7] checking csums against data             ":
> > +			"[5/7] checking csums (without verifying data) ",
> > +		"[6/7] checking root refs                      ",
> > +		"[7/7] checking quota groups                   ",
> > +	};
> > +
> > +	time_t elapsed = time(NULL) - priv->start_time;
> > +	int hours   = elapsed / 3600;
> > +	elapsed    -= hours   * 3600;
> 
> It's not common in btrfs-progs to mix declaration and code.

Fixed.
