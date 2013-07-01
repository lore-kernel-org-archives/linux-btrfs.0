Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:58222 "EHLO
	homiemail-a93.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751486Ab3GACuY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 22:50:24 -0400
From: Shridhar Daithankar <ghodechhap@ghodechhap.net>
To: "Garry T. Williams" <gtwilliams@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unclean shutdown and space cache rebuild
Date: Mon, 01 Jul 2013 08:20:19 +0530
Message-ID: <2982023.ALTX9LRhaY@bheem>
In-Reply-To: <4774295.3Q3X7zsTmb@vfr>
References: <11441914.sRzrmH57Vq@bheem> <4774295.3Q3X7zsTmb@vfr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday, June 30, 2013 01:53:48 PM Garry T. Williams wrote:
> I suspect this is, at least in part, related to severe fragmentation
> in /home.

I don't think so. The problem I have described occur only before anybody logs 
in to the system and /home being a separate partition, it is not the problem 
in this case.
w
> 
> There are large files in these directories that are updated frequently
> by various components of KDE and the Chrome browser.  (Firefox has its
> own databases that are frequently updated, too.)
> 
>     ~/.local/share/akonadi

Thats 3.9MB in my case since I point the akonadi db to a systemwide postgresql 
instance. of course, it will just shift defragmentation there.

>     ~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend

damn!

# filefrag soprano-virtuoso.db                                                                                                             
soprano-virtuoso.db: 10518 extents found
                                                                                                                               
# btrfs fi defrag soprano-virtuoso.db

# filefrag soprano-virtuoso.db
soprano-virtuoso.db: 957 extents found

How much is an extend anyways?  is it a page or 256M?


>     ~/.cache/chromium/Default/Cache
>     ~/.cache/chromium/Default/Media\ Cache

I don't use chromium. but I get the idea.

But in general, how to find out most fragmented files and folders? mouting 
with autodefrag is a serious degradation..

> I improved performance dramatically (orders of magnitude) by copying
> the database files into an empty file that was modified with:
> 
>     chattr -C
> 
> and renaming to make the files no COW.  (Note that this is the only
> way to change an existing file to no COW.)  I also set the same
> attribute on the owning directories so that all new files inherit the
> no COW attribute.
> 
> I suspect there are other files that fragment badly since I see
> periods of high disk activity coming back slowly over a few weeks of
> use after making the modifications above.  I intend to track them down
> and do the same.

hmm.. a trick to find most badly fragmented files/directories and defragment 
them should do too I think.


-- 
Regards
 Shridhar
