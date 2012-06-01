Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33936 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab2FAVP5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jun 2012 17:15:57 -0400
Received: by vcbf11 with SMTP id f11so1561085vcb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jun 2012 14:15:56 -0700 (PDT)
Message-ID: <4FC9310A.7040609@gmail.com>
Date: Fri, 01 Jun 2012 17:15:54 -0400
From: Maxim Mikheev <mikhmv@gmail.com>
MIME-Version: 1.0
To: Gareth Pye <gareth@cerberos.id.au>
CC: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
Subject: Re: Help with data recovering
References: <4FC54A5D.8000600@gmail.com> <4FC55043.4050004@gmail.com> <CAE5mzvg_gLxkYhE1h7aunvvYHgsKjpo2xfLqv4A++S=UAOiySw@mail.gmail.com> <4FC55AB7.3000903@gmail.com> <CAE5mzvjYA-ojJWK8yqTbY6DZCoqcP9B_U2RwYGiahkp3C9t67g@mail.gmail.com> <4FC6D128.60308@gmail.com> <CA+WRLO-mRoSXkdd6_ydc2py3JJCnoM4avQNanxDWWntde2Ah0A@mail.gmail.com>
In-Reply-To: <CA+WRLO-mRoSXkdd6_ydc2py3JJCnoM4avQNanxDWWntde2Ah0A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Seems it does not work.
What should be a next step in data recovering?

On 05/30/2012 10:50 PM, Gareth Pye wrote:
> Stopping an experimental fsck for an exterimental file system would 
> probably be the worst idea possible. I'd only think about stopping it 
> after it had spent many many hours not doing anything*. If it was 
> working hard after 26 hours I'd just keep working
>
> *This isn't advice to stop it if that is true, just a minimal 
> condition on me stopping any fsck.
>
> On Thu, May 31, 2012 at 12:02 PM, Maxim Mikheev <mikhmv@gmail.com 
> <mailto:mikhmv@gmail.com>> wrote:
>
>     btrfsck --repair running already for 26 hours.
>
>     Is it have sense to wait more?
>
>     Thanks
>
>
>     On 05/29/2012 07:36 PM, cwillu wrote:
>
>         On Tue, May 29, 2012 at 5:24 PM, Maxim
>         Mikheev<mikhmv@gmail.com <mailto:mikhmv@gmail.com>>  wrote:
>
>             Thank you for your answer.
>
>
>             The system kernel was and now:
>
>             Linux s0 3.4.0-030400-generic #201205210521 SMP Mon May 21
>             09:22:02 UTC 2012
>             x86_64 x86_64 x86_64 GNU/Linux
>
>             the raid was created by:
>             mkfs.btrfs /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
>
>             Disk are connected through RocketRaid 2670.
>
>             for mounting I used line in fstab:
>             UUID=c9776e19-37eb-4f9c-bd6b-04e8dde97682    /tank      
>              btrfs
>              defaults,compress=lzo    0    1
>
>             On machine was running several Virtual machines. Only one
>             was actively using
>             disks.
>
>             VM has active several threads:
>             1. 2 threads reading big files (50GB each)
>             2. reading from 50 files and writing one big file
>             3. The kernel panic happens when I run another program
>             with 30 threads of
>             reading/writing of small files.
>
>             Virtual Machine accessed to underline btrfs through 9-p
>             file system which
>             actively used xattr.
>
>             After reboot system was in this stage.
>
>             I hope that btrfsck --repair will not make it worse, It is
>             now running.
>
>         **twitch**
>
>         Well, I also hope it won't make it worse.  Do not cancel it
>         now, let
>         it finish (aborting it will  make things worse), but I suggest
>         waiting
>         until a few more people have weighed in before attempting anything
>         beyond that.
>
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-btrfs" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>
>
>
> -- 
> Gareth Pye
> Level 2 Judge, Melbourne, Australia
> Australian MTG Forum: mtgau.com <http://mtgau.com/>
> gareth@cerberos.id.au <mailto:gareth@cerberos.id.au> - 
> www.rockpaperdynamite.wordpress.com 
> <http://www.rockpaperdynamite.wordpress.com/>
> "Dear God, I would like to file a bug report"
>
