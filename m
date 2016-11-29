Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:34164 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbcK2Tlg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 14:41:36 -0500
Received: by mail-io0-f182.google.com with SMTP id c21so292060882ioj.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 11:41:36 -0800 (PST)
Subject: Re: Convert from RAID 5 to 10
To: Lionel Bouton <lionel-subscription@bouton.name>,
        Florian Lindner <mailinglists@xgm.de>, linux-btrfs@vger.kernel.org
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
 <d2551840-173a-712b-4039-99854e62539a@bouton.name>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b773cde4-8d3d-7b5e-a432-39e865c8a201@gmail.com>
Date: Tue, 29 Nov 2016 14:41:22 -0500
MIME-Version: 1.0
In-Reply-To: <d2551840-173a-712b-4039-99854e62539a@bouton.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-29 14:03, Lionel Bouton wrote:
> Hi,
>
> Le 29/11/2016 à 18:20, Florian Lindner a écrit :
>> [...]
>>
>> * Any other advice? ;-)
>
> Don't rely on RAID too much... The degraded mode is unstable even for
> RAID10: you can corrupt data simply by writing to a degraded RAID10. I
> could reliably reproduce this on a 6 devices RAID10 BTRFS filesystem
> with a missing device. It affected even a 4.8.4 kernel where our
> PostgreSQL clusters got frequent write errors (on the fs itself but not
> the 5 working devices) and managed to corrupt their data. Have backups,
> you probably will need them.
>
> With Btrfs RAID If you have a failing device, replace it early (monitor
> the devices and don't wait for them to fail if you get transient errors
> or see worrying SMART values). If you have a failed device, don't
> actively use the filesystem in degraded mode. Replace or delete/add
> before writing to the filesystem again.
This is an excellent point I didn't think of.  If you don't have some 
way you can monitor things, don't trust RAID (not just BTRFS raid modes, 
but any RAID like system in general).  The only reason I'm willing to 
trust it is because I have really good monitoring set up (SMART status 
on the disks + daily scrubs + hourly event counter checks on the FS + 
watching for changes to filesystem flags + a couple of other things) 
which will e-mail me the moment something starts to go bad (and I've 
jumped through hoops to get the mailing to work under almost any 
circumstances as long as userspace still exists and has network access).

I can confirm though that things work well with BTRFS raid1 mode for at 
least the following:
  * Basic, mostly static, network services (DHCP server, DNS relay, web 
server serving static content, very low volume postfix installation, etc).
  * Moderate disk usage in very sequential usage patterns (BOINC 
applications in my case, but almost anything replacing files or 
appending in reasonably sized chunks semi-regularly falls into this).
  * Infrequent typical usage for software builds (I run Gentoo, so 
system updates = building software, and I've never had any issues with 
this (at least, not any issues because of BTRFS)).
  * Bulk sequential streaming of data (stuff like multimedia recordings).

In all cases except the last (which I've only had some limited recent 
experience with), I've had BTRFS raid1 mode filesystems survive just 
fine through:
  * 3 bad PSU's (common case for this is that you see filesystem and 
storage device errors tracing down to the disks at rates proportionate 
to the overall load on the system)
  * 7 different storage devices going bad (1 catastrophic mechanical 
failure, 1 connector failure (poor soldering job for the connector), 2 
disk controller failures, and 3 media failures)
  * 2 intermittently bad storage controllers
  * 100+ kernel panics/crashes
All with no issues with data corruption (there was corruption, but BTRFS 
safely handled all of it and fixed it, and actually helped me diagnose 
two of the bad PSU's and one of the bad storage controllers).  90% of 
the reason it's survived all this though is because of the monitoring I 
have in place which let me track down exactly what was wrong and fix it 
before it became an issue.

