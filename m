Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:39712 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdG0Xik (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 19:38:40 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1dasMW-0002zq-HK
        for linux-btrfs@vger.kernel.org; Fri, 28 Jul 2017 01:38:36 +0200
Date: Fri, 28 Jul 2017 01:38:36 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: Raid0 rescue
Message-ID: <20170727233836.hdwljehqvjjmtc2x@angband.pl>
References: <CAFcRpx4q7N1zG4gz-g6MgkU6c-F_gQ6+2-4ibgm+nyRCp5pTXQ@mail.gmail.com>
 <20170727151038.GT7140@carfax.org.uk>
 <pan$2c543$d5ad45a3$4b673920$5f7cee9a@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <pan$2c543$d5ad45a3$4b673920$5f7cee9a@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 27, 2017 at 08:25:19PM +0000, Duncan wrote:
> >    Welcome to RAID-0...
> 
> As Hugo implies, RAID-0 mode, not just for btrfs but in general, is well 
> known among admins for being "garbage data not worth trying to recover" 
> mode.  Not only is there no redundancy, but with raid0 you're 
> deliberately increasing the chances of loss because now loss of any one 
> device pretty well makes garbage of the entire array, and loss of any 
> single device in a group of more than one is more likely than loss of any 
> single device by itself.

Disks don't quite die once a week, you see.  Using raid0 is actually quite
rational in a good part of setups.

* You need backups _anyway_.  No raid level removes this requirement.
* You can give a machine twice as much immediate storage with raid0 than
  with raid1.
* You get twice as many disks you can use for backup.

Redundant raid is good for two things:
* uptime
* reducing the chance for loss of data between last backup and the failure

For the second point, do you happen to know of a filesystem that gives you
cheap hourly backups that avoid taking half an hour just to stat?


Thus, you need to make a decision: would you prefer to take time trying to
recover, with a good chance of failure anyway -- or a-priori accept that
every failure means hitting the backups?  Obviously, depends on the use
case.

This said, I don't have a raid0 anywhere.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ What Would Jesus Do, MUD/MMORPG edition:
⣾⠁⢰⠒⠀⣿⡁ • multiplay with an admin char to benefit your mortal
⢿⡄⠘⠷⠚⠋⠀ • abuse item cloning bugs (the five fishes + two breads affair)
⠈⠳⣄⠀⠀⠀⠀ • use glitches to walk on water
