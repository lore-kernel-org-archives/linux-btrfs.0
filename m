From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: [PATCH] Deny sys_link across subvolumes.
Date: Fri, 13 Nov 2009 15:17:21 +0900
Message-ID: <4AFCF9F1.9010502@jp.fujitsu.com>
References: <4AEA7A07.4020006@jp.fujitsu.com> <4AFBB5D2.3060405@jp.fujitsu.com> <20091112150039.GD3196@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091112150039.GD3196@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Thu, Nov 12, 2009 at 04:14:26PM +0900, TARUISI Hiroaki wrote:
>> From: Christian Parpart <trapni@gentoo.org>
>>
>> I rebased Christian Parpart's patch to deny hard link across
>> subvolumes. Original patch modifies also btrfs_rename, but
>> I excluded it because we can move across subvolumes now and
>> it make no problem.
> 
> Thanks for sending this in again.
> 
> Actually, we still can't rename across subvolumes, but we do support
> renaming subvolumes.  Do you have some time to add more checks to rename
> as well?
> 
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thank you for your reply.

I tried moving file/directory/subvolume across subvolumes,
and found it worked. In source code of btrfs_rename, it's
already checked if 'from' directory and 'to' directory are
under a same root or not except a root object. If not
matched, btrfs_rename returns with -EXDEV but it seems mv
command treats it properly. Even if in no-check case (root
object case), I tried but found no serious problem.

I wonder renaming subvolumes across subvolumes does not
completely work yet in some points I cannot found, or
btrfs_rename works without returning -EXDEV.

Could you tell me how should we check when renaming
subvolumes?

Regards,
taruisi

