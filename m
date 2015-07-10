Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:35741 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbbGJECx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 00:02:53 -0400
Received: by ykee186 with SMTP id e186so53594766yke.2
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 21:02:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC=t97DfrfSg6SXQa4B3bS_jR2Ge=DdcvxAz0XpgWV0BMwuAoQ@mail.gmail.com>
References: <11148188.L9vtSMaNHV@merkaba> <20150709171737.GS17274@merlins.org>
 <CAC=t97B2L_tKJVByhNni1pqByfFrMQ05C9KK6y_i00N=7zO7_g@mail.gmail.com> <CAC=t97DfrfSg6SXQa4B3bS_jR2Ge=DdcvxAz0XpgWV0BMwuAoQ@mail.gmail.com>
From: Paul Harvey <csirac2@gmail.com>
Date: Fri, 10 Jul 2015 14:02:34 +1000
Message-ID: <CAB3_Qu+fJVB2CpiEO_tgbDUJf=AD6pn0FdBwnhMS5yF8tRq4JA@mail.gmail.com>
Subject: Re: Anyone tried out btrbk yet?
To: Donald Pearson <donaldwhpearson@gmail.com>
Cc: Marc MERLIN <marc@merlins.org>, Martin Steigerwald <martin@lichtvoll.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In my research, I've found btrbk and btrfs-sxbackup certainly to be
the leading contenders in terms of feature completeness. sanoid [1]
will be another interesting possibility once btrfs compatibility is
added (currently zfs only).

I just wish I'd discovered all these before I went to all the effort
of creating snazzer [1] :)

I've been meaning to split some stuff out of snazzer that might be
generically useful to other folks, such as filesystem cloning of all
subvols/snapshots via send/receive, and it seems as if it should be
possible to automatically prune any idiosyncratic snapshot naming
convention - I just haven't found the time to write unit tests.

[1] https://github.com/jimsalterjrs/sanoid
[2] https://github.com/csirac2/snazzer

On 10 July 2015 at 11:38, Donald Pearson <donaldwhpearson@gmail.com> wrote:
> ... and I just found your other block about stealing shlock out of inn.
>
> Officially embarassed!
>
> On Thu, Jul 9, 2015 at 8:35 PM, Donald Pearson
> <donaldwhpearson@gmail.com> wrote:
>> Marc,
>>
>> I thought I'd yours a try, and I'm probably embarassing myself here
>> but I'm running in to this issue.  Centos 7.
>>
>> [root@san01 tank]# ./btrfs-subvolume-backup store /mnt2/backups
>> ./btrfs-subvolume-backup: line 177: shlock: command not found
>> /var/run/btrfs-subvolume-backup held for btrfs-subvolume-backup, quitting
>> [root@san01 tank]# yum whatprovides shlock
>> Loaded plugins: changelog, fastestmirror
>> Loading mirror speeds from cached hostfile
>>  * base: dist1.800hosting.com
>>  * elrepo: repos.dfw.lax-noc.com
>>  * epel: mirror.umd.edu
>>  * extras: mirrors.usc.edu
>>  * updates: mirror.keystealth.orgNo matches found
>> [root@san01 tank]# shlock
>> -bash: shlock: command not found
>> [root@san01 tank]# yum search all shlock
>> Loaded plugins: changelog, fastestmirror
>> Loading mirror speeds from cached hostfile
>>  * base: dist1.800hosting.com
>>  * elrepo: repos.dfw.lax-noc.com
>>  * epel: mirror.utexas.edu
>>  * extras: mirror.thelinuxfix.com
>>  * updates: dallas.tx.mirror.xygenhosting.com
>> Warning: No matches found for: shlock
>> No matches found
>>
>> On Thu, Jul 9, 2015 at 12:17 PM, Marc MERLIN <marc@merlins.org> wrote:
>>> On Thu, Jul 09, 2015 at 02:26:55PM +0200, Martin Steigerwald wrote:
>>>> Hi!
>>>>
>>>> I see Alex, the developer of btrbk posted here once about btrfs send and
>>>> receive, but well any other users of btrbk¹? What are your experiences?
>>>>
>>>> I consider switching to it from my home grown rsync based backup script to
>>>> it.
>>>>
>>>> Well I may try it for one of my BTRFS volumes in addition to the rsync
>>>> backup for now. I would like to give all options on command line, but well,
>>>> maybe it can completely replace my current script if I put everything in its
>>>> configuration.
>>>>
>>>> Any other handy BTRFS backup solutions?
>>>
>>> I use my own which I wrote :)
>>> http://marc.merlins.org/perso/btrfs/2014-03.html#Btrfs-Tips_-Doing-Fast-Incremental-Backups-With-Btrfs-Send-and-Receive
>>> http://marc.merlins.org/linux/scripts/btrfs-subvolume-backup
>>>
>>> Marc
>>> --
>>> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>>> Microsoft is to operating systems ....
>>>                                       .... what McDonalds is to gourmet cooking
>>> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
