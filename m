From: Harshavardhana <harsha@gluster.com>
Subject: Re: [PATCH][TAKE-1] fs/btrfs: Return EPERM for rmdir on subvolumes
 and snapshots
Date: Fri, 09 Apr 2010 11:39:22 -0700
Message-ID: <4BBF745A.9090602@gluster.com>
References: <1270766820-7345-1-git-send-email-harsha@gluster.com> <201004091958.36715.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201004091958.36715.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/09/2010 10:58 AM, Goffredo Baroncelli wrote:
> Can I suggest to return -EINVAL instead of -EPERM ?
> To me EPERM seems that the user don't have the right to perform an action. But
> the problem is that "rm" is not the right command to use in order to delete a
> subvolume.
>
> As side note, what is the reason for which an user is able to create a
> subvolume, but not to destroy it ?
>
> BR
> Goffredo
>
>    
We can decide on that,  but let me explaing in more detail.

 From what i understood is that since when you are not allowed to delete 
the volume or a snapshot by "rmdir" (conventional means). Then it is 
perfectly safe to call it EPERM as it would be as if suggesting 
"pathname" doesn't support removal of directories.

EINVAL is a for other needs which i feel is not suitable in the current 
case.

There is another scenario of what if btrfs_rmdir itself can call subvol 
removal ioctl for snapshots and subvolumes in case someone issues a 
rmdir on such directories.

Suggestions please.

Regards

-- 
Harshavardhana
http://www.gluster.com

