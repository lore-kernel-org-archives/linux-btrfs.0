From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH][TAKE-1] fs/btrfs: Return EPERM for rmdir on subvolumes and snapshots
Date: Fri, 9 Apr 2010 23:42:54 +0200
Message-ID: <201004092342.54329.kreijack@libero.it>
References: <1270766820-7345-1-git-send-email-harsha@gluster.com> <4BBF970E.7000903@gluster.com> <4BBF9863.50504@gluster.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: linux-btrfs@vger.kernel.org
To: Harshavardhana <harsha@gluster.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BBF9863.50504@gluster.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 09 April 2010, Harshavardhana wrote:
> On 04/09/2010 02:07 PM, Harshavardhana wrote:
> > EBUSY is again meant for different reason where in a super block is 
> > being locked or accessed by an Application which would mean unref on 
> > that block would cause Application to go nuts. In such cases EBUSY is 
> > returned. 
> Ok i think ENOTSUPP could be another alternative? . This should be ok i 
> guess?


I prefer ENOTSUP and EINVAL to EPERM. 
But the man page of unlink (2) doesn't cite nor EINVAL nor ENOTSUP.

So at this point I have to admit that EPERM could be the best compromise.

But let me highlight that unlink(2) returns -EBUSY when an user try to delete 
a mount-point. This is quite similar to unlink a subvolume.

So my list in order of preference is

1) EBUSY                   -> because it is used when unlink is called on a
			      mount-point and it is in the unlink (2) man page
2) EPERM		   -> because it is in the unlink man page, and it was
                              already discussed
3) ENOTSUP, EINVAL	   -> to me these make a lot of sense. But the man
			      page doesn't cite both of them

BR
Goffredo

> Regards



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
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
