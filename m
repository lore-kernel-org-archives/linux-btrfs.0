From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [BUG] umount command doesn't end forever
Date: Fri, 2 Sep 2011 15:43:26 +0300
Message-ID: <20110902124325.GA2022@zambezi.lan>
References: <4E6094F5.8000506@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E6094F5.8000506@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 02, 2011 at 05:33:57PM +0900, Tsutomu Itoh wrote:
> In current for-linus branch, I encountered the problem that the
> umount command doesn't end forever.

(snipped)

> umount acquires down_write(&s->s_umount) by deactivate_super() and
> waits for the end of btrfs-cleaner.
> But, btrfs-cleaner stops because of the acquisition waiting of
> down_read(&sb->s_umount) by writeback_inodes_sb_nr_if_idle().

A similar thing happens on remount while balancing, I think I saw this
in some other case too.  It's always due to the fact that vfs acquires
s_umount for read/write and then the writeback code wants to down_read()
it (in case of balancing it has nothing to do with the cleaner thread,
balance calls into writeback by itself).

> So, the deadlock has happened, I think.
> 
>  -Tsutomu
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
