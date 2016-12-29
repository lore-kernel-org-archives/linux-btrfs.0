Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55255 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750767AbcL2Tbh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Dec 2016 14:31:37 -0500
From: Rene Wolf <igeligel@gmx.net>
Subject: Re: Incremental send receive of snapshot fails
To: Giuseppe Della Bianca <g.dellabianca@gestiware.it>
References: <1483025509.3496.34.camel@localhost>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <274dac29-62b2-b366-8bbc-b2c55773c113@gmx.net>
Date: Thu, 29 Dec 2016 20:31:28 +0100
MIME-Version: 1.0
In-Reply-To: <1483025509.3496.34.camel@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi


As the fs in question is my root, I tried the following using a live usb 
stick of a xubuntu 16.10:

> Checking filesystem on /dev/sdb1
> UUID: 122ecca7-9804-4c8a-b4ed-42fd6c6bbe7a
> checking extents [o]
> checking free space cache [.]
> checking fs roots [o]
> found 40577679360 bytes used err is 0
> total csum bytes: 39027548
> total tree bytes: 571277312
> total fs tree bytes: 453001216
> total extent tree bytes: 71745536
> btree space waste bytes: 116244847
> file data blocks allocated: 46952968192
>  referenced 44081487872

"err is 0" ... so I guess that means everything is fine?

Out of curiosity I retried the new_snap+send+receive on that same fs 
using the live cd: same results (ERROR unlink ...)
Though I noticed that the exact file in question (reported by ERROR) is 
somewhat random ...
For this test with the live usb, I mounted the root volume directly 
instead of subvolumes via fstab. So that doesn't seam to have been the 
problem either.


I did some further meditating on what happens here. From what I read and 
understand of send/receive, the stream produced by send is about 
replaying the fs events. If I give send a parent, it will just replay 
the difference between the two snapshots and only produce a stream that 
contains the changes needed to "transform" one (parent) snap into the 
other (on the receiving end). Now I'm not sure how the receiving end 
figures out what the parent is, and whether it has it, but I guess 
that's where all those UUIDs come into play.

There are three UUIDs, if I compare them on sending ("lab") and 
receiving ("server") side, I see:

## sender
# btrfs subv show /.back/last_snap_by_script
> /.back/last_snap_by_script
>         UUID:                   b4634a8b-b74b-154a-9f17-1115f6d07524
>         Parent UUID:            b5f9a301-69f7-0646-8cf1-ba29e0c24fac
>         Received UUID:          196a0866-cd05-d24e-bac6-84e8e5eb037a

## receiver
# btrfs subv show /media/bak/lab/root/last_snap_by_script
>         UUID:                   89321ec1-2de6-0a4c-8f9f-cdd30fa3a7af
>         Parent UUID:            -
>         Received UUID:          196a0866-cd05-d24e-bac6-84e8e5eb037a

So that does make sense to me, as neither "Parent UUID" nor "UUID" is 
what would fit our needs (both are kind of local to one system). Instead 
the "Received UUID" seams to be the link identifying snaps on both ends 
to be "equal". But then why do both snaps on the sending side have the 
same "Received UUID" for me:

## from my original post, on sender side, this is the "new" delta snapshot
# btrfs subv show /.back/new_snap
> /.back/new_snap
>         Name:                   new_snap
>         UUID:                   fca51929-8101-db45-8df6-f25935c04f98
>         Parent UUID:            b5f9a301-69f7-0646-8cf1-ba29e0c24fac
>         Received UUID:          196a0866-cd05-d24e-bac6-84e8e5eb037a


It would be great if some one could clear this up .. could this point to 
the reason on why the "replay" stream is produced on a wrong basis?

Another thing I tried is the "--max-error 0" option of receive. That 
lets it continue after error, but that produced an endless slur of more 
of the same errors. Is that another indicator that the parent on the 
sending or receiving side is identified wrongly or not at all?

In any case, thanks for the tip Giuseppe :-)


Regards
Rene

On 29.12.2016 16:31, Giuseppe Della Bianca wrote:
> Hi.
>
> In such cases, I have run btrfs check (not repair mode !!!) in every
> file system/partition that is involved in creating, sending and
> receiving snapshots.
>
>
> Regards.
>
> Gdb
