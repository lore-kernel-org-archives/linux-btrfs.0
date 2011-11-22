From: Arne Jansen <sensille@gmx.net>
Subject: Re: Recovering data from old corrupted file system
Date: Tue, 22 Nov 2011 09:23:55 +0100
Message-ID: <4ECB5C1B.5000505@gmx.net>
References: <CAGh96GFUS-1X-o8n+N_fCRc=6nViru+tM9obJMgSYuLf7D-MpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Erik Jensen <eriksjunk@rkjnsn.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAGh96GFUS-1X-o8n+N_fCRc=6nViru+tM9obJMgSYuLf7D-MpQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 22.11.2011 04:19, Erik Jensen wrote:
> I have a corrupted multi-device file system that got corrupted ages
> ago (as I recall, one of the drives stopped responding, causing btrfs
> to panic). I am hoping to recover some of the data. For what it's
> worth, here is the dmesg output from trying to mount the file system
> on a 3.0 kernel:
> 
> device label Media devid 6 transid 816153 /dev/sdq
> device label Media devid 7 transid 816153 /dev/sdl
> device label Media devid 11 transid 816153 /dev/sdj
> device label Media devid 9 transid 816153 /dev/sdk
> device label Media devid 10 transid 816153 /dev/sdi
> device label Media devid 3 transid 816152 /dev/sdh
> device label Media devid 4 transid 816152 /dev/sdf
> device label Media devid 1 transid 816152 /dev/sdg
> device label Media devid 2 transid 816152 /dev/sde
> device label Media devid 8 transid 816153 /dev/sdb
> parent transid verify failed on 47051597279232 wanted 816153 found 816151
> parent transid verify failed on 47051597279232 wanted 816153 found 816151
> parent transid verify failed on 47051597279232 wanted 816153 found 816151
> 
> Most of the data is unimportant at this point, and I don't have enough
> extra space elsewhere to store it all anyway. Is there any way I could
> get a read-only view of the file system to pull off the bits I need?

There are some patches in preparation that should help you
recover from this situation. The solution is to mount with
a superblock of generation 816152, but the current set of
tools won't allow for that.

> 
> Any help would be greatly appreciated.
> 
> Thanks.
> 
> -- Erik Jensen
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

