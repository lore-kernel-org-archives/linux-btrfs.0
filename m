Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbcEJHmZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 03:42:25 -0400
Date: Tue, 10 May 2016 09:42:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: switch to common message helpers in open_ctree,
 adjust messages
Message-ID: <20160510074203.GP29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462786798-15247-1-git-send-email-dsterba@suse.com>
 <573148AB.6080800@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <573148AB.6080800@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 10, 2016 at 10:34:19AM +0800, Anand Jain wrote:
> On 05/09/2016 05:39 PM, David Sterba wrote:
> > Currently we lack the identification of the filesystem in most if not
> > all mount messages, done via printk/pr_* functions. We can use the
> > btrfs_* helpers in open_ctree, as the fs_info <-> sb link is established
> > at the beginning of the function.
> 
>   While here I also recommend to pass fs_devices instead of fs_info
>   to btrfs_printk(). That's mainly because before the fs is mounted
>   we don't have fs_info, however fs_devices exists in both the mounted
>   and unmount context.  If you agree, I could send a patch on top of
>   your patch.

Yeah, before we mount we don't have fs_info. My idea was to provide
another set of functions that would take something else than fs_info to
print the filesystem identifier.

Switching btrfs_err & others to fs_devices everywhere would be too
invasive.

In more detail:

* introduce _btrfs_printk that takes a string pointer as 1st argument
  (this could be used for messages before fs_info exists)
* _btrfs_printk(NULL, ...) will be valid
* then btrfs_printk(fs_info, ...) will become a wrapper
  _btrfs_printk(btrfs_sb(fs_info)->s_id, ...)
* _btrfs_err & others do not need to be introduced, we can use the
  standard KERN_ERR

>   Otherwise the rest below looks fine.

Thnaks.
