From: Andy Lutomirski <luto@mit.edu>
Subject: Re: BUG: Link from sub volume, then remove the subvolume -> wrong
   link
Date: Sat, 12 Dec 2009 13:39:52 -0500
Message-ID: <4B23E378.1090905@mit.edu>
References: <200912112054.25986.kreijack@libero.it> <4B22E2D8.7020706@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: kreijack@libero.it, linux-btrfs@vger.kernel.org
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B22E2D8.7020706@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

TARUISI Hiroaki wrote:
> Hi,
> 
>  I don't know how a hard link becomes to a soft link, hard link
> across subvolumes should not allowed in btrfs.
> 
>  Hard link contains target inode number but not target tree.
> So, if we can create such hard link normally, it points to
> a file which has same inode number in same subvolume.
>  As for this problem, Christian Parpart posted a patch, and
> I rebased it.

Can you post a link?  I'd like to test it, and it should probably go 
into -stable (since it fixes an oops that can be triggered without 
privileges).

Thanks,
Andy
