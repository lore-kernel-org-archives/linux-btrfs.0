From: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: Can I use ionice?
Date: Thu, 29 Jul 2010 13:47:59 +0530
Message-ID: <201007291347.59955.knikanth@suse.de>
References: <loom.20100729T095825-295@post.gmane.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: mukai <mukai@visionstream.co.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20100729T095825-295@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 29 July 2010 13:30:13 mukai wrote:
> Hi
> 
> Can I use ionice on btrfs?
> 

Yes, you can. I/O priorities are honoured by the I/O scheduler, independant of 
the file-system. And only cfq supports I/O priorities.

Thanks
Nikanth

> Thanks
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
