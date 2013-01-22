Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41498 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3AVRDb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 12:03:31 -0500
Received: by mail-wi0-f181.google.com with SMTP id hq4so6115174wib.14
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 09:03:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMO4zugaABrbTJB75Yyi_UravfSX81YyqJtmc3yGALrby7+RTQ@mail.gmail.com>
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
	<20130121184016.GC7971@twin.jikos.cz>
	<CAMO4zugaABrbTJB75Yyi_UravfSX81YyqJtmc3yGALrby7+RTQ@mail.gmail.com>
Date: Tue, 22 Jan 2013 22:33:29 +0530
Message-ID: <CAMO4zuhVCQgFnxa6YDd1vjn9iQQxx80iiWTGasDMFjR7yEn3JQ@mail.gmail.com>
Subject: Fwd: [PATCH 00/13] Btrfs-progs: more patches for integration (integration-20130121)
From: praneeth u <praneethu.u@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
We are team of 5 students, interns at Green turtles technologies,
interested in contributing to btrfs.
Any space for contribution for btrfs testing ? we will be updating
pogress twice in a week.
Need suggestions on how to proceed.

On Tue, Jan 22, 2013 at 12:10 AM, David Sterba <dsterba@suse.cz> wrote:
> On Sun, Jan 20, 2013 at 04:04:05PM -0500, Gene Czarcinski wrote:
>> I have done some additional scraping of the mailing list to
>> identify some "low hanging fruit" which I consider should
>> be merged into the btrfs-progs repository.
>
> Thanks, I went through them and put together into an integration branch
>
>   git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130121
>
> I've modified the signed-off-by lines when I knew who was the author or
> contributed to the patch. Please let me know if I've messed the credits
> and fame attribution.
>
> There are three more patches that I've picked from my distro patch queue (and
> were sent to the list long ago) they're placed at the top of the shortlog.
>
> Arne Jansen (1):
>       Btrfs-progs: bugfix for scrubbing single devices
>
> Wang Sheng-Hui (1):
>       btrfs-progs: add malloc check in transaction.h/btrfs_start_transaction
>
> Goffredo Baroncelli (1):
>       Ignore the error ENXIO and ENOMEDIUM during a devs scan
>
> Arvin Schnell (1):
>       btrfs-progs: initialize data before send ioctl
>
> Danny Kukawka (1):
>       btrfs-progs: Handle errors returned from open_ctree
>
> Jan Schmidt (2):
>       Btrfs-progs: correcting misnamed parameter options for btrfs send
>       Btrfs-progs: bugfix for subvolume parent determination in btrfs send
>
> Josef Bacik (2):
>       Btrfs-progs: detect if the disk we are formatting is a ssd
>       Btrfs-progs: add btrfs device ready command
>
> Nirbheek Chauhan (1):
>       Btrfs-progs: fix resolving of loop devices
>
> Stefan Behrens (1):
>       btrfs-progs: Add btrfs-show-super
>
> Ulrik (1):
>       Btrfs-progs: correct btrfs receive usage string
>
> Wang Shilong (3):
>       Btrfs-progs: fix arg parsing for btrfs qgroup limit commands
>       Btrfs-progs: clean up reduplicate parse_qgroupid() and replace atoi with strtoull
>       Btrfs-progs: check the relation of two group by real level numbers
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Praneeth U
9448804728


--
Praneeth U
9448804728
