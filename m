Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29408 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750950AbaJJKsf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 06:48:35 -0400
From: Josef Bacik <jbacik@fb.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: repair missing dir index
Date: Fri, 10 Oct 2014 10:48:30 +0000
Message-ID: <sny3yei3qm53bf1qcre260c4.1412938108721@email.android.com>
References: <1412275839-8131-1-git-send-email-jbacik@fb.com>,<20141010084323.GG22943@twin.jikos.cz>
In-Reply-To: <20141010084323.GG22943@twin.jikos.cz>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm redoing this patch a bit so don't take it yet. Thanks,

Josef

David Sterba <dsterba@suse.cz> wrote:


On Thu, Oct 02, 2014 at 02:50:39PM -0400, Josef Bacik wrote:
> +static int repair_inode_backrefs(struct btrfs_root *root,
> +                              struct inode_record *rec,
> +                              struct cache_tree *inode_cache)
> +{
> +     struct btrfs_trans_handle *trans;
> +     struct btrfs_path *path;
> +     struct inode_backref *tmp, *backref;
> +     u64 root_dirid = btrfs_root_dirid(&root->root_item);
> +     int ret;

Changed to ret = 1,

> +     list_for_each_entry_safe(backref, tmp, &rec->backrefs, list) {
[...]
> +     }

gcc prints warning about possibly unitilized ret here:

> +     BUG_ON(repaired && ret); /* Poor mans transaction abort */

So it would abort in case the list_for_each loop does not execute for
some reason.
