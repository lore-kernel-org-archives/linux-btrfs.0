From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: BUG: Link from sub volume, then remove the subvolume -> wrong
   link
Date: Mon, 14 Dec 2009 08:42:44 +0900
Message-ID: <4B257BF4.5060807@jp.fujitsu.com>
References: <200912112054.25986.kreijack@libero.it> <4B22E2D8.7020706@jp.fujitsu.com> <4B23E378.1090905@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: kreijack@libero.it, linux-btrfs@vger.kernel.org
To: luto@mit.edu
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B23E378.1090905@mit.edu>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

We can see the patch in ML archive or at 'Patchwork' site.

  http://patchwork.kernel.org/patch/59519/

Thanks,
taruisi

(2009/12/13 3:39), Andy Lutomirski wrote:
> TARUISI Hiroaki wrote:
>> Hi,
>>
>>  I don't know how a hard link becomes to a soft link, hard link
>> across subvolumes should not allowed in btrfs.
>>
>>  Hard link contains target inode number but not target tree.
>> So, if we can create such hard link normally, it points to
>> a file which has same inode number in same subvolume.
>>  As for this problem, Christian Parpart posted a patch, and
>> I rebased it.
> 
> Can you post a link?  I'd like to test it, and it should probably go
> into -stable (since it fixes an oops that can be triggered without
> privileges).
> 
> Thanks,
> Andy

