Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:34868 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933112AbdDAADW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 20:03:22 -0400
Received: by mail-wm0-f43.google.com with SMTP id y22so9350642wmh.0
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 17:03:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <22750.48060.805852.28370@tree.ty.sabi.co.uk>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
 <20170327130730.GN11714@carfax.org.uk> <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
 <20170327194847.5c0c5545@natsu> <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
 <22746.30348.324000.636753@tree.ty.sabi.co.uk> <43e29da2-1d1b-1680-f262-1c95575645d8@gmail.com>
 <22749.10893.729399.275210@tree.ty.sabi.co.uk> <d2f4af84-739e-d43c-0978-8bbe74e8a277@gmail.com>
 <22750.37100.788020.938846@tree.ty.sabi.co.uk> <CAP8EXU2cdtVP7+Qgy6mTJ1oqCmpW4JpaoUxAsf0RZ27WprvZ3g@mail.gmail.com>
 <22750.48060.805852.28370@tree.ty.sabi.co.uk>
From: GWB <gwb@2realms.com>
Date: Fri, 31 Mar 2017 19:02:40 -0500
Message-ID: <CAP8EXU3YZLn1K6v8JLB_47Y1kVOb4uFgLmnn1Lr3iSsaHLkz6w@mail.gmail.com>
Subject: Re: Shrinking a device - performance?
To: Peter Grandi <pg@btrfs.list.sabi.co.uk>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is confusing, and now that I look at it, more than a little funny.
Your use of xargs returns the size of the kernel module for each of
the filesystem types.  I think I get it now: you are pointing to how
large the kernel module for btrfs is compared to other file system
kernel modules, 833 megs (piping find through xargs to sed).  That
does not mean the btrfs kernel module can accommodate an upper limit
of a command line length that is 833 megs.  It is just a very big
loadable kernel module.

So same question, but different expression: what is the signifigance
of the large size of the btrfs kernel module?  Is it that the larger
the module, the more complex, the more prone to breakage, and more
difficult to debug?  Is the hfsplus kernel module less complex, and
more robust?  What did the file system designers of hfsplus (or udf)
know better (or worse?) than the file system designers of btrfs?

VAX/VMS clusters just aren't happy outside of a deeply hidden bunker
running 9 machines in a cluster from one storage device connected by
myranet over 500 miles to the next cluster.  I applaud the move to
x86, but like I wrote earlier, time has moved on.  I suppose weird is
in the eye of the beholder, but yes, when dial up was king and disco
pants roamed the earth, they were nice.  I don't think x86 is a viable
use case even for OpenVMS.  If you really need a VAX/VMS cluster,
chances are you have already have had one running with a continuous
uptime of more than a decade and you have already upgraded and changed
out every component several times by cycling down one machine in the
cluster at a time.

Gordon

On Fri, Mar 31, 2017 at 3:27 PM, Peter Grandi <pg@btrfs.list.sabi.co.uk> wrote:
>> [ ... ] what the signifigance of the xargs size limits of
>> btrfs might be. [ ... ] So what does it mean that btrfs has a
>> higher xargs size limit than other file systems? [ ... ] Or
>> does the lower capacity for argument length for hfsplus
>> demonstrate it is the superior file system for avoiding
>> breakage? [ ... ]
>
> That confuses, as my understanding of command argument size
> limit is that it is a system, not filesystem, property, and for
> example can be obtained with 'getconf _POSIX_ARG_MAX'.
>
>> Personally, I would go back to fossil and venti on Plan 9 for
>> an archival data server (using WORM drives),
>
> In an ideal world we would be using Plan 9. Not necessarily with
> Fossil and Venti. As a to storage/backup/archival Linux based
> options are not bad, even if the platform is far messier than
> Plan 9 (or some other alternatives). BTW I just noticed with a
> search that AWS might be offering Plan 9 hosts :-).
>
>> and VAX/VMS cluster for an HA server. [ ... ]
>
> Uhmmm, however nice it was, it was fairly weird. An IA32 or
> AMD64 port has been promised however :-).
>
> https://www.theregister.co.uk/2016/10/13/openvms_moves_slowly_towards_x86/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
