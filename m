Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:61335 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3CFJJD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Mar 2013 04:09:03 -0500
Received: by mail-lb0-f175.google.com with SMTP id n3so5411647lbo.6
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Mar 2013 01:09:01 -0800 (PST)
Date: Wed, 6 Mar 2013 11:08:57 +0200
From: Ilya Dryomov <idryomov@gmail.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, alex.btrfs@zadarastorage.com
Subject: Re: [PATCH v2] btrfs: clean snapshots one by one
Message-ID: <20130306090857.GA1953@zambezi.lan>
References: <CAOcd+r152Ot9RYjGfCc_sW46BNKuKrhEN=xR_hw_9QKSu5Agpw@mail.gmail.com>
 <1362154654-17655-1-git-send-email-dsterba@suse.cz>
 <20130301163057.GW27541@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130301163057.GW27541@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 01, 2013 at 05:30:57PM +0100, David Sterba wrote:
> The mail did not make it to the list on Monday, anyway, now I have a
> few testing results to share.
> 
> The umount responsiveness is much improved, it took a few seconds when
> there were many roots to clean scheduled.
> 
> With
> 
> $ echo 'func btrfs_drop_snapshot +pf' > /sys/debug/kernel/dynamic_debug/control
> $ echo 'func btrfs_clean_one_deleted_snapshot +pf' > /sys/debug/kernel/dynamic_debug/control
> 
> one can watch how it proceeds.
> 
> After umount and and mount, the cleaning process starts again, after 30
> seconds when transaction commit triggers.
> 
> Next test was to let it run with balance (just 'fi balance', no other
> options). Worked well, but I've hit an oops from balance cancel command that
> was triggered sometime during the balance. According to the log it happened
> right after the balance finished. CCing Ilya, I'm not sure if this is somehow
> induced by the patch.
> 
> 3407         BUG_ON(fs_info->balance_ctl || atomic_read(&fs_info->balance_running));

Were you by any chance running this on top of a for-linus that included
a raid56 merge commit?  If so, this is result of a raid56 mismerge --
fs_info->balance_ctl is supposed to be cleared in __cancel_balance(), a
call to which was accidentally nuked.

Thanks,

		Ilya
