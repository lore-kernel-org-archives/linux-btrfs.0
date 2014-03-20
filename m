Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:58396 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaCTHh7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 03:37:59 -0400
Received: by mail-ve0-f176.google.com with SMTP id cz12so473018veb.7
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Mar 2014 00:37:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140320004651.GZ18959@merlins.org>
References: <1394983430-20440-1-git-send-email-fdmanana@gmail.com>
 <1395002246-3840-1-git-send-email-fdmanana@gmail.com> <20140316222026.GU16946@merlins.org>
 <pan$2239d$446ec5c7$d67506b7$f25a7c65@cox.net> <20140319060902.GM6143@merlins.org>
 <CD1D8CED-8BC2-4C16-AE9E-0C47DC954CFA@colorremedies.com> <20140319154031.GP6143@merlins.org>
 <EBE67530-BDC7-487C-826D-A0E65259BCBA@colorremedies.com> <20140319224034.GV18959@merlins.org>
 <CAGwxe4jL+L571MtEmeHnTnHQSD7h+2ApfWqycgV-ymXhfMR-JA@mail.gmail.com> <20140320004651.GZ18959@merlins.org>
From: Tobias Holst <tobby@tobby.eu>
Date: Thu, 20 Mar 2014 08:37:38 +0100
Message-ID: <CAGwxe4iH5jAC51z1tBFEHsDXsaCgGGiq8Xb4mQQU58e20wdwGA@mail.gmail.com>
Subject: Re: How to handle a RAID5 arrawy with a failing drive? -> raid5
 mostly works, just no rebuilds
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think after the balance it was a fine, non-degraded RAID again... As
far as I remember.

Tobby


2014-03-20 1:46 GMT+01:00 Marc MERLIN <marc@merlins.org>:
>
> On Thu, Mar 20, 2014 at 01:44:20AM +0100, Tobias Holst wrote:
> > I tried the RAID6 implementation of btrfs and I looks like I had the
> > same problem. Rebuild with "balance" worked but when a drive was
> > removed when mounted and then readded, the chaos began. I tried it a
> > few times. So when a drive fails (and this is just because of
> > connection lost or similar non severe problems), then it is necessary
> > to wipe the disc first before readding it, so btrfs will add it as a
> > new disk and not try to readd the old one.
>
> Good to know you got this too.
>
> Just to confirm: did you get it to rebuild, or once a drive is lost/gets
> behind, you're in degraded mode forever for those blocks?
>
> Or were you able to balance?
>
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/
