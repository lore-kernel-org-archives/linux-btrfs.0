Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:43505 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3FZLC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 07:02:29 -0400
Received: by mail-la0-f50.google.com with SMTP id dy20so13397799lab.9
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 04:02:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130624152547.GH4288@localhost.localdomain>
References: <CAOEw3RbTrQkogo44sxdo62+Y8yJd_Bp_QTPQWW7-FVcv4TrJ6w@mail.gmail.com>
	<20130624152547.GH4288@localhost.localdomain>
Date: Wed, 26 Jun 2013 13:02:27 +0200
Message-ID: <CAOEw3RZOFQVmSVrc8osxWafDhJFe1hfM7FkaLxsN-2pGB-3Hog@mail.gmail.com>
Subject: Re: Btrfs lockup during defrag and removing device
From: =?ISO-8859-2?Q?Ond=F8ej_Kunc?= <kunc88@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

I can confirm, that I'm not able to crash it when I didn't run defrag
during other operations. So as you wish, I will place "me too" in
bugzilla, as I see, there is a patch available, so I will test it asap
(just need to patch&compile kernel, because I was testing debian
package before).

Thank you all for nice work

Ondrej

2013/6/24 Josef Bacik <jbacik@fusionio.com>:
> On Mon, Jun 24, 2013 at 12:25:07PM +0200, Ondøej Kunc wrote:
>> Hi developers,
>>
>> I have been playing with btrfs on our test server. I have streessed it
>> much ... and I can say ... it's troughput and features are very nice
>> and usable, but I experienced one problem during testing, btrfs
>> triggered lockup of 3 of 8 CPU cores of testing server.
>>
>> What I was doing ?
>>
>> Simultaneously:
>> - copying 130GB file on one subvolume to another file and measuring speed by pv
>> - removing one device (/dev/md3) from btrfs
>> - running btrfs defrag on whole  fs (via xargs)
>> - rsyncing files from another server to subvolume
>> - untaring the first 130GB tar to one subdirectory
>>
>> Our server is HP-DL380, 12*146GB SAS HDD, 72GB RAM, Intel Xeon 5620
>> Running uptodate debian wheezy with kernel and btrfs-tools from testing
>> 3.9-1-amd64 #1 SMP Debian 3.9.6-1 x86_64 GNU/Linux
>> # btrfs version
>> Btrfs Btrfs v0.19
>>
>> btrfs was created on top on 3 software RAID6 devices, every one built
>> from 4 SAS drive
>>
>> About one hour after this(see dmesg) server became inaccessible, so I
>> had to restart it by power cycle.
>>
>> After reboot there was problem with free space cache, but it was fixed
>> automatically. I have one suspection, I have tried next this:
>>
>> btrfs balance start /btrfs
>> and then btrfs resize 4:max /btrfs (device was previosly smaller)
>>
>> it failed with dmesg output: btrfs: dev
>> add/delete/balance/replace/resize operation in progress.
>>
>> So it is possible, that it is mutualy exclusive and should not be
>> permitted in the other way, to start balance or defrag when device is
>> being removed, is this true ?
>>
>> Thank you all for your good work!
>>
>> Ondrej Kunc
>>
>> dmesg output: http://pastebin.com/Ndxypkxa
>>
>
> So it seems like you hit some bug higher up that just made the system devolve
> into this chain of panics.  I think you are probably hitting this
>
> https://bugzilla.kernel.org/show_bug.cgi?id=59451
>
> which the strato guys are working on.  If you take the "btrfs defrag" step out
> of that test do you still have the same problem?  If yes then it may be
> something new and could you file a new bugzilla if thats the case?  If it
> doesn't reproduce with taking out the defrag step then just attach yourself to
> that bugzilla with a "me too" so you can test whatever patch we come up with.
> Thanks,
>
> Josef



--
Ondøej Kunc
