Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25854 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbcBNVcg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 16:32:36 -0500
Date: Sun, 14 Feb 2016 13:32:24 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: =?utf-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
Message-ID: <20160214213224.GB28882@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAJCQCtRjCixev=Mt=jaL1ZytYaxj7Fa-AViLYGB-ALufyL98VA@mail.gmail.com>
 <CAJCQCtRtVjyjvSfT=BCZZwfaSvbD4YVxEBezfAx+-q7cwMHmRQ@mail.gmail.com>
 <CABXGCsNivrLgTEE+HZOLHXA-kpLVQOUv9L_nTw96nvy+DHodZg@mail.gmail.com>
 <CAJCQCtTrcnwvumgt-bOx+9wX+f50S9ja5rDrnYAsuuN1aDTsZA@mail.gmail.com>
 <20160211191741.GA4762@localhost.localdomain>
 <CABXGCsPN3MOLkU68gpw=TsnZLODEkYZ66ZHgUxMyeqbdNME9Sw@mail.gmail.com>
 <20160212032226.GA10542@localhost.localdomain>
 <CABXGCsNjHq4M8TBibeWQLyK+Of0cu++P3QQ=+e=TUuZjaPMLtA@mail.gmail.com>
 <20160212203426.GA24399@localhost.localdomain>
 <CABXGCsMMkcMmEH8=d3TqJksB8uc_OVrRqfjX7E1RO+4R94O=Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CABXGCsMMkcMmEH8=d3TqJksB8uc_OVrRqfjX7E1RO+4R94O=Ug@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mike,
On Sun, Feb 14, 2016 at 12:23:16AM +0500, Михаил Гаврилов wrote:
> Sorry, I have not yet had time to apply your patch.
> 
> And get hang again when launch web browser.
> 
> Here new logs: http://btrfs.sy24.ru/kernel-sysrqw-btrfscleaner770blocked-3.txt

The logs show,
every hung process is waiting for fs tree root's WRITE_LOCK, but someone who's
holding the WRITE_LOCK is not reflected here.

Only one suspicious process is 
"Chrome_FileThre D ffff8807fe1d7a18 10360 22486   2826 0x00000000"
it's also waiting on btrfs_tree_lock(), but I can't tell whether it
waits for the fs tree root node's lock or the children node's lock.

Hmm, sorry for not being helpful, but I was wondering if this also
occurs on the latest btrfs(4.5) or is it possible to give it a shot?

The best result is that it's been fixed by one commit in 4.5.

> 
> Addition info: when btrfs partition hangs also hang GUI it is normal?
> For grab logs I switch to tty3 (Ctrl - Alt - F3)

I'm afraid the answer is yes because GUI needs to read files (like
config files) from the underlying partition.

Thanks,

-liubo

> 
> 
> 
> --
> Best Regards,
> Mike Gavrilov.
> 
> 
> 2016-02-13 1:34 GMT+05:00 Liu Bo <bo.li.liu@oracle.com>:
> > On Sat, Feb 13, 2016 at 12:15:08AM +0500, Михаил Гаврилов wrote:
> >> 2016-02-12 8:22 GMT+05:00 Liu Bo <bo.li.liu@oracle.com>:
> >> > You can try it on your 4.2.3 kernel or the latest 4.5, but I guess it
> >> > doesn't not fix the real deadlock you're hitting...
> >>
> >> It means it is not final patch? you continue investigate problem? Can
> >> I help you?
> >
> > Yeah, it's not the final patch, you can apply it and see if the deadlock
> > will happen again.
> >
> > Unless we can get a way to reproduce it, I'm afraid there's little things we can  do here.
> >
> > Thanks,
> >
> > -liubo
