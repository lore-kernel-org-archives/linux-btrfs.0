Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:38435 "EHLO
	mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbcHOORI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 10:17:08 -0400
Received: by mail-it0-f52.google.com with SMTP id n128so8218431ith.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 07:17:08 -0700 (PDT)
Subject: Re: Huge load on btrfs subvolume delete
To: Daniel Caillibaud <ml@lairdutemps.org>,
        btrfs ml <linux-btrfs@vger.kernel.org>
References: <20160815123928.47bd2c03@asus17.lairdutemps.org>
 <95c98a1b-4484-c294-fcd6-001e73cd25d6@gmail.com>
 <20160815160641.79063cec@asus17.lairdutemps.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5b02565e-95b2-cc9d-154f-b9e8805dbed4@gmail.com>
Date: Mon, 15 Aug 2016 10:16:45 -0400
MIME-Version: 1.0
In-Reply-To: <20160815160641.79063cec@asus17.lairdutemps.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-15 10:06, Daniel Caillibaud wrote:
> Le 15/08/16 à 08:32, "Austin S. Hemmelgarn" <ahferroin7@gmail.com> a écrit :
>
> ASH> On 2016-08-15 06:39, Daniel Caillibaud wrote:
> ASH> > I'm newbie with btrfs, and I have pb with high load after each btrfs subvolume delete
> […]
>
> ASH> Before I start explaining possible solutions, it helps to explain what's
> ASH> actually happening here.
> […]
>
> Thanks a lot for these clear and detailed explanations.
Glad I could help.
>
> ASH> > Is there a better way to do so ?
>
> ASH> While there isn't any way I know of to do so, there are ways you can
> ASH> reduce the impact by reducing how much your backing up:
>
> Thanks for these clues too !
>
> I'll use --commit-after, in order to wait for complete deletion before starting rsync the next
> snapshot, and I keep in mind the benefit of putting /var/log outside the main subvolume of the
> vm (but I guess my main pb is about databases, because their datadir are the ones with most
> writes).
>
With respect to databases, you might consider backing them up separately 
too.  In many cases for something like an SQL database, it's a lot more 
flexible to have a dump of the database as a backup than it is to have 
the database files themselves, because it decouples it from the 
filesystem level layout.  Most good databases should be able to give you 
a stable dump (assuming of course that the application using the 
databases is sanely written) a whole lot faster than you could back up 
the files themselves.  For the couple of databases we use internally 
where I work, we actually back them up separately not only to retain 
this flexibility, but also because we have them on a separate backup 
schedule from the rest of the systems because they change a lot more 
frequently than anything else.
