From: Harshavardhana <harsha@gluster.com>
Subject: Re: [PATCH][TAKE-1] fs/btrfs: Return EPERM for rmdir on subvolumes
 and snapshots
Date: Fri, 09 Apr 2010 14:07:26 -0700
Message-ID: <4BBF970E.7000903@gluster.com>
References: <1270766820-7345-1-git-send-email-harsha@gluster.com> <201004091958.36715.kreijack@libero.it> <4BBF745A.9090602@gluster.com> <201004092054.48946.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201004092054.48946.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/09/2010 11:54 AM, Goffredo Baroncelli wrote:
>         EBUSY (not on Linux)
>                The file pathname cannot be unlinked because it is being used by
>                the system or another process and the  implementation  considers
>                this an error.
>
> [...]
>         EPERM  The system does not allow unlinking of directories, or unlinking
>                of directories requires  privileges  that  the  calling  process
>                doesn't  have.   (This  is the POSIX prescribed error return; as
>                noted above, Linux returns EISDIR for this case.)
>
>         EPERM (Linux only)
>                The file system does not allow unlinking of files.
>
> [...]
>
> In fact when I tried to unlink a directory where a filesystem is mounted, I
> got -EBUSY. So for consistency EBUSY may be another error which may be
> returned.
>    

EBUSY is again meant for different reason where in a super block is 
being locked or accessed by an Application which would mean unref on 
that block would cause Application to go nuts. In such cases EBUSY is 
returned.


-- 

Harshavardhana
http://www.gluster.com

