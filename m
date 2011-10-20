From: Martin Mailand <martin@tuxadero.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:1163
Date: Thu, 20 Oct 2011 15:04:31 +0200
Message-ID: <4EA01C5F.9040506@tuxadero.com>
References: <4E9DDBB1.2050007@tuxadero.com> <4E9EE687.4020202@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Cc: linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
To: Anand Jain <anand.jain@oracle.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4E9EE687.4020202@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,
I changed the replication level of the rbd pool, from one to two.
ceph osd pool set rbd size 2

And then during the sync the bug happened, but today I could not 
reproduce it.

So I do not have a testcase for you.

Best Regards,
  martin

Am 19.10.2011 17:02, schrieb Anand Jain:
> I tried to play with ceph here and not a complete success yet.
>
>   any idea what was done on the system at the time of the problem ?
>   and any specific command that could trigger this again ?
>   Thanks.
> anand

