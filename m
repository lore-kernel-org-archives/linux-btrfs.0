Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:55221 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409AbbJKVyf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 17:54:35 -0400
Received: from [192.168.47.124] (81-65-101-84.rev.numericable.fr [81.65.101.84])
	by box.speed47.net (Postfix) with ESMTPSA id 411A8A143
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2015 23:54:31 +0200 (CEST)
From: =?iso-8859-1?B?U3TpcGhhbmUgTGVzaW1wbGU=?=
	<stephane_btrfs@lesimple.fr>
To: <linux-btrfs@vger.kernel.org>
Date: Sun, 11 Oct 2015 23:54:26 +0200
Message-ID: <15058e5ca50.2785.faeb54a6cf393cf366ff7c8c6259040e@lesimple.fr>
In-Reply-To: <15058e034a0.2785.faeb54a6cf393cf366ff7c8c6259040e@lesimple.fr>
References: <CAEtw4r3r-E1deboGDCfNkUL-ZKUdn4+B++oeu9M4H_7hHDj0TA@mail.gmail.com>
 <BLU436-SMTP5651E81A1B27D60895E652A9340@phx.gbl>
 <CAEtw4r3Qg-5cian-GjAuCmjaTnzea0OrHgxZO_VM1OwjoF2oxQ@mail.gmail.com>
 <CAEtw4r2HMrJciX4tgC9d9qSVucCJng-tyJxWPFX7h-5oqePV_w@mail.gmail.com>
 <CAEtw4r0mGLUS5HPfxeu5ip57iLk3SeJ04nJsr9CTchXu2mMMkw@mail.gmail.com>
 <CAEtw4r27FonYkrgdm8sdu1vLYP8KTdjWuu8=tOEatqJ8esRvgg@mail.gmail.com>
 <CAEtw4r2GQMhfmk0TLiM12C6GSCQz7Ph4DYx-wzrCDn+bbbx4pw@mail.gmail.com>
Subject: Re: kernel BUG at /linux/fs/btrfs/extent-tree.c:1833!
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Peter,

I have the same problem you have, as reported ~1 month ago on this 
mailing-list.

My setup is 2 disks, and I tried balancing after adding a third one, in a 
raid5 configuration.
I also have some "extent buffer leak" in my btrfsck, but it's hard to say 
if it can be the cause. If you look at the source code you'll see that 
those messages are not printed by the main checking routine but by an 
helper subroutine, I'm not even sure it represents a problem on the 
filesystem (maybe somebody can sched some light here).

I tried with the 4.3-rc2 kernel, and the kernel bug is still there, 
unfortunately. I also posted an ftrace of the bug, hopefully somebody with 
enough btrfs knowledge will have a look.
I reproduced this bug dozens of time, and as far as I can tell I never lost 
any single byte because of the crash, probably thanks to the transaction 
system of btrfs, so, at least there's that.

-- 
Stéphane.


Le 11 octobre 2015 22:50:07 Peter Becker <floyd.net@gmail.com> a écrit :

> the output of btrfs check --readonly /dev/sdb
>
> http://pastebin.com/UxkeVd7Y
>
> many entrys with "extent buffer leak"
>
>
> the output of  btrfs-show-super -i0 /dev/sd[bcd] &&  btrfs-show-super
> -i1 /dev/sd[bcd] &&  btrfs-show-super -i2 /dev/sd[bcd]
>
> http://pastebin.com/zs7B8827
> http://pastebin.com/Kn1kwgYv
> http://pastebin.com/CHC52ef7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


