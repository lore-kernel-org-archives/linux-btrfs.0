From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH][TAKE-1] fs/btrfs: Return EPERM for rmdir on subvolumes and snapshots
Date: Fri, 9 Apr 2010 20:54:48 +0200
Message-ID: <201004092054.48946.kreijack@libero.it>
References: <1270766820-7345-1-git-send-email-harsha@gluster.com> <201004091958.36715.kreijack@libero.it> <4BBF745A.9090602@gluster.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: linux-btrfs@vger.kernel.org
To: Harshavardhana <harsha@gluster.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BBF745A.9090602@gluster.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ok,

I read the unlink (2) man page which says:

[...]
       EBUSY (not on Linux)
              The file pathname cannot be unlinked because it is being used by
              the system or another process and the  implementation  considers
              this an error.

[...]
       EPERM  The system does not allow unlinking of directories, or unlinking
              of directories requires  privileges  that  the  calling  process
              doesn't  have.   (This  is the POSIX prescribed error return; as
              noted above, Linux returns EISDIR for this case.)

       EPERM (Linux only)
              The file system does not allow unlinking of files.

[...]

In fact when I tried to unlink a directory where a filesystem is mounted, I 
got -EBUSY. So for consistency EBUSY may be another error which may be 
returned.


On Friday 09 April 2010, Harshavardhana wrote:
> On 04/09/2010 10:58 AM, Goffredo Baroncelli wrote:
> > Can I suggest to return -EINVAL instead of -EPERM ?
> > To me EPERM seems that the user don't have the right to perform an action. 
But
> > the problem is that "rm" is not the right command to use in order to 
delete a
> > subvolume.
> >
> > As side note, what is the reason for which an user is able to create a
> > subvolume, but not to destroy it ?
> >
> > BR
> > Goffredo
> >
> >    
> We can decide on that,  but let me explaing in more detail.
> 
>  From what i understood is that since when you are not allowed to delete 
> the volume or a snapshot by "rmdir" (conventional means). Then it is 
> perfectly safe to call it EPERM as it would be as if suggesting 
> "pathname" doesn't support removal of directories.
> 
> EINVAL is a for other needs which i feel is not suitable in the current 
> case.
> 
> There is another scenario of what if btrfs_rmdir itself can call subvol 
> removal ioctl for snapshots and subvolumes in case someone issues a 
> rmdir on such directories.
> 
> Suggestions please.
> 
> Regards
> 
> -- 
> Harshavardhana
> http://www.gluster.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
