Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55789 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab3GRAvz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 20:51:55 -0400
Received: by mail-ob0-f174.google.com with SMTP id wd20so3109660obb.33
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 17:51:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130717230401.GA2581@localhost.localdomain>
References: <CAKuK5J0ZiMnAHWAEvNBESX99cawYJQ4_sFQ=5_Ka8gwJqLT2cA@mail.gmail.com>
 <20130717230401.GA2581@localhost.localdomain>
From: Jon Nelson <jnelson@jamponi.net>
Date: Wed, 17 Jul 2013 19:51:34 -0500
Message-ID: <CAKuK5J2opbAWNmYsdSVkWAopyfPip8rypW7yKADEBCyqXb6Qxw@mail.gmail.com>
Subject: Re: report: my btrfs filesystem failed hard today
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 17, 2013 at 6:04 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Wed, Jul 17, 2013 at 05:44:23PM -0500, Jon Nelson wrote:
>> I had a btrfs filesystem under 3.9.8 that failed /hard/ today. So hard
>> that the filesystem could not be mounted because there wasn't enough
>> free space, unless it was mounted read only.
>>
>> This happened after I ran out of metadata space (is there a way to
>> increase the amount of metadata storage) while still having many gigs
>> free of data space, as reported by btrfs fi df. I tried balancing the
>> metadata, defrag'ing files (with -czlib) and even tried mounting with
>> -o remount,metadata_ratio={several values}, none of which worked, and
>> then it crashed hard.
>>
>> First, it killed systemd's logger (journald), which refused to
>> start.Following the crash, I was not able to mount the filesystem
>> without -o ro.  -o recovery did not work.
>>
>
> Can you try btrfs-next, I did some work in this area in the last few months.

Unfortunately, I could not wait. I reaaaaly needed that system back
up, so I copied everything off, reformatted with ext4, and copied it
all back.
I (probably?) have more logs, though.


--
Jon
Software Blacksmith
