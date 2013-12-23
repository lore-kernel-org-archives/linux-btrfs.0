Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20924 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756670Ab3LWKRS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Dec 2013 05:17:18 -0500
Message-ID: <52B80DFA.5060409@cn.fujitsu.com>
Date: Mon, 23 Dec 2013 18:18:34 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Geert Jansen <geertj@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: list_del corruption
References: <CADbA=FVN5juGTxFZKdj_gqmJ5aGSyzikXMW9HDUAciBX1mUWzg@mail.gmail.com>
In-Reply-To: <CADbA=FVN5juGTxFZKdj_gqmJ5aGSyzikXMW9HDUAciBX1mUWzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	mon, 23 Dec 2013 09:49:16 +0100, Geert Jansen wrote:
> Hi,
> 
> myself, and some other Fedora users, are experiencing a crash in
> btrfs. I am using Fedora 20 with its stock kernel (3.12.5 based). The
> call trace is here:
> 
>   https://retrace.fedoraproject.org/faf/reports/226666/
> 
> I have no way to reproduce unfortunately. The crash happens about once a week.
> 
> There is also a Red Hat bugzilla here:
> 
>   https://bugzilla.redhat.com/show_bug.cgi?id=1028750
> 
> The Red Hat bugzilla contains a patch for 3.13 that is claimed to fix
> the issue. However the patch does not apply cleanly, and the comment
> in the patch indicate that it fixes a different, more recently
> introduced bug.
> 
> Any help is appreciated.

It should be fixed by:

commit 93858769172c4e3678917810e9d5de360eb991cc
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Mon Oct 28 09:13:25 2013 -0400

    Btrfs: take ordered root lock when removing ordered operations inode
    
    A user reported a list corruption warning from btrfs_remove_ordered_extent, it
    is because we aren't taking the ordered_root_lock when we remove the inode from
    the ordered operations list.  Thanks,
    
    Signed-off-by: Josef Bacik <jbacik@fusionio.com>
    Signed-off-by: Chris Mason <chris.mason@fusionio.com>

Thanks
Miao

> 
> Thanks,
> Geert Jansen
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

