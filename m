Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:32878 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbbGAQJ0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jul 2015 12:09:26 -0400
Received: by oiyy130 with SMTP id y130so35524977oiy.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2015 09:09:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSjxs2ZZUgUfrp9q5y+x0fFA7fSnQPgeEXTjsLKZ6DPKw@mail.gmail.com>
References: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>
 <CAJCQCtSjxs2ZZUgUfrp9q5y+x0fFA7fSnQPgeEXTjsLKZ6DPKw@mail.gmail.com>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Wed, 1 Jul 2015 11:09:05 -0500
Message-ID: <CAC=t97BiPjTf7yjWoSaoTgjvPZFgyEHdEJzFCG1Mu+nnJGoNoA@mail.gmail.com>
Subject: Re: Any hope of pool recovery?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Chris,

To my shame it turns out darkling didn't drop off IRC after all; I'm
new to all this and learning quickly that I need to sit on my hands.
I admit despite darkling's suggestion that my usertools are probably
fine I pulled down a newer kernel from elrepo so currently I'm running
4.1.1-1.el7.elrepo.x86_64

I started with 4.0.2-1.el7.elrepo.x86_64

I also do have btrfs-progs 4.1 that I got from git.

Here is the 4.0 output
[root@san01 btrfs-progs]# btrfs check /dev/sdc
checksum verify failed on 21364736 found E4E3BDB6 wanted 00000000
checksum verify failed on 21364736 found E4E3BDB6 wanted 00000000
checksum verify failed on 21364736 found EC809498 wanted 0863292E
checksum verify failed on 21364736 found 925303CE wanted 09150E74
checksum verify failed on 21364736 found 925303CE wanted 09150E74
bytenr mismatch, want=21364736, have=1065943040
Couldn't read chunk tree
Couldn't open file system

Here is the 4.1 output
[root@san01 btrfs-progs]# ./btrfs check /dev/sdc
checksum verify failed on 21364736 found E4E3BDB6 wanted 00000000
checksum verify failed on 21364736 found E4E3BDB6 wanted 00000000
checksum verify failed on 21364736 found EC809498 wanted 0863292E
checksum verify failed on 21364736 found 925303CE wanted 09150E74
checksum verify failed on 21364736 found 925303CE wanted 09150E74
bytenr mismatch, want=21364736, have=1065943040
Couldn't read chunk tree
Couldn't open file system

Finally, before I learned of this mailing list I started a run of
btrfs rescue chunk-recover
[root@san01 btrfs-progs]# ./btrfs rescue chunk-recover -v /dev/sdc

I can see now through iostat that all 10 drives are reading as fast as
they can and my understanding is this will take a long time, but I've
since learned (not only that darkling was still alive on IRC) that
this probably won't solve my problem.

Regards,
Donald (seijirou)

On Wed, Jul 1, 2015 at 10:50 AM, Chris Murphy <lists@colorremedies.com> wrote:
> btrfs-progs version is 4.0, what is the kernel versions you've tried
> to mount with?
>
> I suggest running btrfs check (without --repair) and including the
> full output. There are a lot of changes in btrfs-progs 4.1, but off
> hand I don't know that they'd affect btrfs check results.
>
>
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
