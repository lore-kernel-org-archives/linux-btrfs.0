Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754134AbdEZTJn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 15:09:43 -0400
Date: Fri, 26 May 2017 21:08:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/8] btrfs: qgroup.h whitespace change
Message-ID: <20170526190843.GP30842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170520083826.GA4176@ircssh-2.c.rugged-nimbus-611.internal>
 <20170520083935.GA4235@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170520083935.GA4235@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 20, 2017 at 08:39:37AM +0000, Sargun Dhillon wrote:
> This patch is just changing whitespace alignment in qgroup.h

>  int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
> -			      struct btrfs_fs_info *fs_info, u64 qgroupid);
> +			struct btrfs_fs_info *fs_info, u64 qgroupid);

Please don't send such changes.

https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#How_not_to_start

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Cleanup_projects

"Please note that pure whitespace and style reformatting changes are not
really necessary at this phase of development. They get fixed along
regular changes. Possibly once upon in a while a patch that fixes many
if not all whitespace errors could work, but otherwise it's considered a
noise. "
