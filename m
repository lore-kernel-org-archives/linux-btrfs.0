Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61796 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3F3Rxv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 13:53:51 -0400
Received: by mail-gh0-f174.google.com with SMTP id r17so1679138ghr.33
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 10:53:50 -0700 (PDT)
Received: from vfr.localnet (adsl-98-88-119-147.asm.bellsouth.net. [98.88.119.147])
        by mx.google.com with ESMTPSA id z65sm27381606yhc.9.2013.06.30.10.53.49
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Sun, 30 Jun 2013 10:53:50 -0700 (PDT)
From: "Garry T. Williams" <gtwilliams@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: unclean shutdown and space cache rebuild
Date: Sun, 30 Jun 2013 13:53:48 -0400
Message-ID: <4774295.3Q3X7zsTmb@vfr>
In-Reply-To: <11441914.sRzrmH57Vq@bheem>
References: <11441914.sRzrmH57Vq@bheem>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6-30-13 19:26:16 Shridhar Daithankar wrote:
> Whenever there is a unclean shutdown(which happens a lot in my
> case), the next reboot, system comes up relatively at the same speed
> but as systemd is starting up daemons, the disk is continuously (and
> unusally long) grinding.

[snip]

> How can I confirm that it is the space cache rebuild thats taking
> time?
> 
> if space cache rebuild is the reason, is there any way to improve
> it?
> 
> I am running archlinux/systemd/kde

I suspect this is, at least in part, related to severe fragmentation
in /home.

There are large files in these directories that are updated frequently
by various components of KDE and the Chrome browser.  (Firefox has its
own databases that are frequently updated, too.)

    ~/.local/share/akonadi
    ~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend
    ~/.cache/chromium/Default/Cache
    ~/.cache/chromium/Default/Media\ Cache

I improved performance dramatically (orders of magnitude) by copying
the database files into an empty file that was modified with:

    chattr -C

and renaming to make the files no COW.  (Note that this is the only
way to change an existing file to no COW.)  I also set the same
attribute on the owning directories so that all new files inherit the
no COW attribute.

I suspect there are other files that fragment badly since I see
periods of high disk activity coming back slowly over a few weeks of
use after making the modifications above.  I intend to track them down
and do the same.

Also, see these:

    https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#Defragmenting_a_directory_doesn.27t_work 
    https://btrfs.wiki.kernel.org/index.php/UseCases#How_do_I_defragment_many_files.3F 

    $ uname -r
    3.9.6-200.fc18.x86_64
    $

-- 
Garry T. Williams

