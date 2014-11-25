Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:41104 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaKYO6F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 09:58:05 -0500
Received: by mail-lb0-f175.google.com with SMTP id u10so685209lbd.34
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 06:58:03 -0800 (PST)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        XFS Developers <xfs@oss.sgi.com>
Subject: Re: [PATCH-v3 3/6] vfs: don't let the dirty time inodes get more than a day stale
References: <1416893674-419-1-git-send-email-tytso@mit.edu>
	<1416893674-419-4-git-send-email-tytso@mit.edu>
Date: Tue, 25 Nov 2014 15:58:01 +0100
In-Reply-To: <1416893674-419-4-git-send-email-tytso@mit.edu> (Theodore Ts'o's
	message of "Tue, 25 Nov 2014 00:34:31 -0500")
Message-ID: <87ioi3iayu.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 25 2014, Theodore Ts'o <tytso@mit.edu> wrote:

>  static int update_time(struct inode *inode, struct timespec *time, int flags)
>  {
> +	struct timespec uptime;
> +	unsigned short daycode;
>  	int ret;
>  
>  	if (inode->i_op->update_time) {
> @@ -1525,17 +1527,33 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
>  		if (flags & S_CTIME)
>  			inode->i_ctime = *time;
>  		if (flags & S_MTIME)
> -			inode->i_mtime = *time;
> +		inode->i_mtime = *time;
>  	}
> +	/*
> +	 * If i_ts_dirty_day is zero, then either we have not deferred
> +	 * timestamp updates, or the system has been up for less than
> +	 * a day (so days_since_boot is zero), so we defer timestamp
> +	 * updates in that case and set the I_DIRTY_TIME flag.  If a
> +	 * day or more has passed, then i_ts_dirty_day will be
> +	 * different from days_since_boot, and then we should update
> +	 * the on-disk inode and then we can clear i_ts_dirty_day.
> +	 */

I think days_since_boot was a lot clearer than daycode. In any case,
please make the comment and the code consistent.

>  	if ((inode->i_sb->s_flags & MS_LAZYTIME) &&
>  	    !(flags & S_VERSION)) {
>  		if (inode->i_state & I_DIRTY_TIME)
>  			return 0;
> -		spin_lock(&inode->i_lock);
> -		inode->i_state |= I_DIRTY_TIME;
> -		spin_unlock(&inode->i_lock);
> -		return 0;
> +		get_monotonic_boottime(&uptime);
> +		daycode = div_u64(uptime.tv_sec, (HZ * 86400));

You should probably divide by the number of seconds in a day, not the
number of jiffies in a day.

Isn't div_u64 mostly for when the divisor is not known at compile time?
Technically, "(u64)uptime.tv_sec / 86400" is of course a u64/u64 division,
but the compiler should see that the divisor is only 32 bits and hence
should be able to generate code which is at least as efficient as
whatever inline asm the arch provides for u64/u32 divisions.


Rasmus
