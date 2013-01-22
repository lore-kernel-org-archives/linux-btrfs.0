Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fed1rmfepo103.cox.net ([68.230.241.145]:48614 "EHLO
	fed1rmfepo103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab3AVSJL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 13:09:11 -0500
Received: from fed1rmimpo306 ([68.230.241.174]) by fed1rmfepo103.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130122180910.THQQ30259.fed1rmfepo103.cox.net@fed1rmimpo306>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 22 Jan 2013 13:09:10 -0500
Message-ID: <50FED5C5.1050007@czarc.net>
Date: Tue, 22 Jan 2013 13:09:09 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: dsterba@suse.cz
Subject: Re: [PATCH 00/13] Btrfs-progs: more patches for integration (integration-20130121)
References: <1358715858-4469-1-git-send-email-gene@czarc.net> <20130121184016.GC7971@twin.jikos.cz>
In-Reply-To: <20130121184016.GC7971@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks.  I am currently running with all of my submissions and 
everything is working.  I will pull your integration branch and switch 
to that instead of 13 patch set so I can test them.  This will be on top 
of the "original" two sets of patches.

Gene

On 01/21/2013 01:40 PM, David Sterba wrote:
> On Sun, Jan 20, 2013 at 04:04:05PM -0500, Gene Czarcinski wrote:
>> I have done some additional scraping of the mailing list to
>> identify some "low hanging fruit" which I consider should
>> be merged into the btrfs-progs repository.
> Thanks, I went through them and put together into an integration branch
>
>    git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130121
>
> I've modified the signed-off-by lines when I knew who was the author or
> contributed to the patch. Please let me know if I've messed the credits
> and fame attribution.
>
> There are three more patches that I've picked from my distro patch queue (and
> were sent to the list long ago) they're placed at the top of the shortlog.
>
> Arne Jansen (1):
>        Btrfs-progs: bugfix for scrubbing single devices
>
> Wang Sheng-Hui (1):
>        btrfs-progs: add malloc check in transaction.h/btrfs_start_transaction
>
> Goffredo Baroncelli (1):
>        Ignore the error ENXIO and ENOMEDIUM during a devs scan
>
> Arvin Schnell (1):
>        btrfs-progs: initialize data before send ioctl
>
> Danny Kukawka (1):
>        btrfs-progs: Handle errors returned from open_ctree
>
> Jan Schmidt (2):
>        Btrfs-progs: correcting misnamed parameter options for btrfs send
>        Btrfs-progs: bugfix for subvolume parent determination in btrfs send
>
> Josef Bacik (2):
>        Btrfs-progs: detect if the disk we are formatting is a ssd
>        Btrfs-progs: add btrfs device ready command
>
> Nirbheek Chauhan (1):
>        Btrfs-progs: fix resolving of loop devices
>
> Stefan Behrens (1):
>        btrfs-progs: Add btrfs-show-super
>
> Ulrik (1):
>        Btrfs-progs: correct btrfs receive usage string
>
> Wang Shilong (3):
>        Btrfs-progs: fix arg parsing for btrfs qgroup limit commands
>        Btrfs-progs: clean up reduplicate parse_qgroupid() and replace atoi with strtoull
>        Btrfs-progs: check the relation of two group by real level numbers
>
> david
>
>

