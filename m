From: "Ian! D. Allen" <idallen@idallen.ca>
Subject: Re: [PATCH v2 5/5] Btrfs: Add BTRFS_IOC_SUBVOL_GETFLAGS/SETFLAGS
 ioctl
Date: Fri, 10 Dec 2010 02:49:34 -0500
Message-ID: <20101210074934.GE9893@idallen.ca>
References: <4D009CD2.3060805@cn.fujitsu.com>
 <4D009D42.1020002@cn.fujitsu.com>
 <201012092109.05720.kreijack@libero.it>
 <4D01D2E9.9000007@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Li Zefan <lizf@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D01D2E9.9000007@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 10, 2010 at 03:12:41PM +0800, Li Zefan wrote:
> >> +	/* nothing to do */
> >> +	if (!!(flags & BTRFS_SUBVOL_RDONLY) == root->readonly)
> >> +		goto out_unlock;
> > 
> > This is only an aesthetic comment: I prefer a simpler style like
> > 
> > 	if ((flags & BTRFS_SUBVOL_RDONLY) && root->readonly)
> > 		goto out_unlock;
> 
> They are not equivalent. The former checks if the flags and the
> root both have readonly bit set or cleared.

This is an excellent reason to add what you just replied (above) as a
comment into the code ahead of that line, so others don't make the same
mistake in interpreting what it does:

        /* nothing to do */
        /* check if flags and root both have readonly bit set or cleared */
        if (!!(flags & BTRFS_SUBVOL_RDONLY) == root->readonly)
                goto out_unlock;

"Debugging is twice as hard as writing the code in the first place.
 Therefore, if you write the code as cleverly as possible, you are,
 by definition, not smart enough to debug it." - Brian W. Kernighan

-- 
| Ian! D. Allen  -  idallen@idallen.ca  -  Ottawa, Ontario, Canada
| Home Page: http://idallen.com/   Contact Improv: http://contactimprov.ca/
| College professor (Free/Libre GNU+Linux) at: http://teaching.idallen.com/
| Defend digital freedom:  http://eff.org/  and have fun:  http://fools.ca/
