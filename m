Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50032 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbaIAQ1c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Sep 2014 12:27:32 -0400
Date: Mon, 1 Sep 2014 09:27:13 -0700
From: Marc MERLIN <marc@merlins.org>
To: Jean-Denis Girard <jd.girard@sysnux.pf>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140901162713.GS23400@merlins.org>
References: <53FE1DB2.8040900@sysnux.pf>
 <pan$2ed7a$1001c22e$8c89f27e$d20dc522@cox.net>
 <262E2EAA-FE5F-4ADB-9D1D-258D51D81AFE@colorremedies.com>
 <ltnnfo$a57$1@ger.gmane.org>
 <54002E66.703@gmail.com>
 <lttb7j$ef$1@ger.gmane.org>
 <lttfit$lk7$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <lttfit$lk7$1@ger.gmane.org>
Subject: Re: Undelete files / directory
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 30, 2014 at 11:26:52AM -1000, Jean-Denis Girard wrote:
> So I commented out the break on line 238 of btrfs-find-root so that it

Thanks for that report.
Can a developer review this and see if it should be made an option or
removed entirely?

Marc

> continues even if it thinks it went past the fs size, rerun the command,
> and I finally got a list of blocks to try!
> 
> Then as you suggested I did:
> for i in `awk '{print $3}' root.txt`
>  do echo "------------------------  $i --------------------"
>  btrfs restore -v -f $i --path-regex '^/(|jdg(|/tmp(|/.*)))$' \
> 	../x220_home.img .
> done
> 
> And I now have back my ~2800 photos (~13 Gb).
> 
> Many thanks to those who helped!
> 
> 
> Best regards,
> Jean-Denis Girard
> 
> 
> Le 30/08/2014 10:12, Jean-Denis Girard a écrit :
> > Le 28/08/2014 21:40, Konstantinos Skarlatos a écrit :
> >> On 28/8/2014 8:04 μμ, Jean-Denis Girard wrote:
> >>> Hi Chris,
> >>>
> >>> Thanks for your detailed answer.
> >>>
> >>> Le 28/08/2014 06:25, Chris Murphy a écrit :
> >>>> 9. btrfs-find-root /dev/sdc
> >>>> Super think's the tree root is at 29917184, chunk root 20987904
> >>>> Well block 4194304 seems great, but generation doesn't match, have=2,
> >>>> want=9 level 0
> >>>> Well block 4243456 seems great, but generation doesn't match, have=3,
> >>>> want=9 level 0
> >>>> Well block 29376512 seems great, but generation doesn't match,
> >>>> have=4, want=9 level 0
> >>>> Well block 29474816 seems great, but generation doesn't match,
> >>>> have=5, want=9 level 0
> >>>> Well block 29556736 seems great, but generation doesn't match,
> >>>> have=6, want=9 level 0
> >>>> Well block 29736960 seems great, but generation doesn't match,
> >>>> have=7, want=9 level 0
> >>>> Well block 29900800 seems great, but generation doesn't match,
> >>>> have=8, want=9 level 0
> >> Hi all,
> >>
> >> I did a successful btrfs restore a few months ago, saving all of my
> >> deleted files except 2 (So i lost about 1GB on a 4TB filesystem)
> >> Here is what i did (this is from memory and from my .zsh_history file,
> >> so i may be missing something)
> >>
> >> btrfs-find-root  /dev/sdd -o 5 > b1.txt
> >> I think the -o 5 option is quite important here.
> > 
> > Thanks for the reply, but for some reason btrfs-fins-root does not work
> > on this file system. Here is what I get:
> > 
> > [jdg@tiare tmp]$ btrfs-find-root x220_home.img -o 5
> > Super think's the tree root is at 115230801920, chunk root 131072
> > Went past the fs size, exiting[jdg@tiare tmp]$
> > 
> > I can mount the file system, access the files, though obviously not the
> > deleted directory.
> > 
> > 
> > 
> > Regards,
> > Jean-Denis Girard
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
