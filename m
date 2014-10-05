Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34471 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaJEXQN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Oct 2014 19:16:13 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:53654 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1Xav25-0005aT-6I by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sun, 05 Oct 2014 16:16:12 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <marc@merlins.org>)
	id 1Xav28-0007zg-JP
	for linux-btrfs@vger.kernel.org; Sun, 05 Oct 2014 16:16:08 -0700
Date: Sun, 5 Oct 2014 16:16:08 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20141005231608.GL10696@merlins.org>
References: <20141005202937.GK10696@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141005202937.GK10696@merlins.org>
Subject: Re: 3.16.2 btrfs deadlock -> detecting deadlocks with cron
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 05, 2014 at 01:29:37PM -0700, Marc MERLIN wrote:
> Deadlocks have been less frequent (good), but here is one.
> 
> An rsync from 5 days ago got stuck on btrfs it seems, and things just 
> started piling up on top until the system deadlocked

This gave me a chance to fix my cronjob that should have detected this
earlier (there is no fix but rebooting, but I can reboot earlier and
before the watchdog kills everything without syncing my software raid
five arrays first).

I just polished and released the crontab below (posted on
http://marc.merlins.org/perso/btrfs/post_2014-10-05_Btrfs-Tips_-Catch-Btrfs-Deadlocks.html
)

You can paste this template in your crontab 

SHELL=/bin/bash

# If load average is more than MAXLA, show load average and all blocked processes
# As any time show anything blocked on wait_current_trans.isra.15 (used to be a btrfs hang bug)
# Also show swap if it drops below MINSWAP
# We pipe into bc because shell comparison doesn't do floating point.
*/5 * * * * nobody MAXLA=25; MINSWAP=10; if [[ $(echo "$(awk '{print $1}' < /proc/loadavg) > $MAXLA" | bc) == 1 ]]; then cat /proc/loadavg; ps -eo state,pid,etime,wchan:30,args | grep W |grep -v "^[RS]" ; fi; ps -eo pid,etime,wchan:30,args | grep -q [w]ait_current_trans.isra.15; if [[ $(echo "$(free | grep 'Swap' | awk '{t = $2; f = $4; print (f/t*100)}') < $MINSWAP" | bc) == 1 ]]; then free; fi

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
