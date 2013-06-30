Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-4.server.virginmedia.net ([80.0.253.68]:55582
	"EHLO know-smtprelay-omc-4.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab3F3UEy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 16:04:54 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by phoenix.fire (8.14.5/8.14.5) with ESMTP id r5UJwxhb005269
	for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 20:59:00 +0100
Message-ID: <51D08E02.3030406@petezilla.co.uk>
Date: Sun, 30 Jun 2013 20:58:58 +0100
From: Pete <pete@petezilla.co.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: unclean shutdown and space cache rebuild
References: <11441914.sRzrmH57Vq@bheem> <4774295.3Q3X7zsTmb@vfr>
In-Reply-To: <4774295.3Q3X7zsTmb@vfr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/30/2013 06:53 PM, Garry T. Williams wrote:
> On 6-30-13 19:26:16 Shridhar Daithankar wrote:
>> Whenever there is a unclean shutdown(which happens a lot in my
>> case), the next reboot, system comes up relatively at the same speed
>> but as systemd is starting up daemons, the disk is continuously (and
>> unusally long) grinding.
>

>> I am running archlinux/systemd/kde
>
> I suspect this is, at least in part, related to severe fragmentation
> in /home.
>

I'm wondering if this is affecting myself.  I have a big issue with my 
data drive slowing down and there being near long periods of high disk 
IO that prevent me doing anything else.  I've noticed from iotop various 
btrfs processes hogging the IO for long periods, e.g. 
btrfs-transacti... & btrfs-submit

I've been running kde which has got unusable (not from reboot, but in 
general).  xfce is less hampered but IO still seems like an issue at 
times.  Of course, xfce hits different files.  I've been using this file 
system a couple of months and not defragged before.  I started 
defragging the various subvolumes a week or two ago - but I did not 
realise this was not recursive until this weekend.  I've got a python 
script running defrag on various files and folders - I can better track 
what it is defragging.  But it is _slow_ many many minutes for a rarely 
accessed folder with little content.  Is this normal?

I too had an issue with unclean shutdowns.  I, relatively infrequently, 
get lockups.  However, I had a spate last week which I have yet to 
resolve.  I wonder if that is related.

I wonder, if I defrag everything on say a weekly basis then will these 
performance issues go away?  Running a 3.9.3 kernel.

Pete



> There are large files in these directories that are updated frequently
> by various components of KDE and the Chrome browser.  (Firefox has its
> own databases that are frequently updated, too.)
>
>      ~/.local/share/akonadi
>      ~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend
>      ~/.cache/chromium/Default/Cache
>      ~/.cache/chromium/Default/Media\ Cache
>
> I improved performance dramatically (orders of magnitude) by copying
> the database files into an empty file that was modified with:
>
>      chattr -C
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
>
> Also, see these:
>
>      https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#Defragmenting_a_directory_doesn.27t_work
>      https://btrfs.wiki.kernel.org/index.php/UseCases#How_do_I_defragment_many_files.3F
>
>      $ uname -r
>      3.9.6-200.fc18.x86_64
>      $
>

