Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:57998 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaDYJlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 05:41:10 -0400
Received: by mail-pd0-f173.google.com with SMTP id p10so2618200pdj.32
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Apr 2014 02:41:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <12598280.ebLKYkuoEp@merkaba>
References: <12598280.ebLKYkuoEp@merkaba>
Date: Fri, 25 Apr 2014 11:41:09 +0200
Message-ID: <CAPpBBdPgzpD8vrMxjgz1y_WL9qfFsTi0vzuB=sEKm6VZcUBHPQ@mail.gmail.com>
Subject: Re: how to cancel scrub which got aborted due to hardly switching off
 the machine?
From: George Eleftheriou <eleftg@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

rm /var/lib/btrfs/scrub-<bla-bla-bla-bla>

On Fri, Apr 18, 2014 at 7:18 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Hello,
>
> I have:
>
> merkaba:/mnt#1> btrfs scrub status -d /home
> scrub status for […]
> scrub device /dev/dm-0 (id 1) status
>         scrub started at Fri Apr 18 17:48:10 2014, running for 335 seconds
>         total bytes scrubbed: 74.80GiB with 0 errors
> scrub device /dev/mapper/sata-home (id 2) status
>         scrub started at Fri Apr 18 17:48:10 2014, running for 335 seconds
>         total bytes scrubbed: 69.86GiB with 0 errors
>
>
> merkaba:/mnt#2> btrfs scrub resume /home
> ERROR: scrub is already running.
> To cancel use 'btrfs scrub cancel /home'.
> To see the status use 'btrfs scrub status [-d] /home'.
>
>
> merkaba:/mnt#1> btrfs scrub cancel /home
> ERROR: scrub cancel failed on /home: not running
>
> merkaba:~> btrfs scrub start /home
> ERROR: scrub is already running.
> To cancel use 'btrfs scrub cancel /home'.
> To see the status use 'btrfs scrub status [-d] /home'.
>
>
> merkaba:~> cat /proc/version
> Linux version 3.14.0-tp520 (martin@merkaba) (gcc version 4.8.2 (Debian
> 4.8.2-17) ) #52 SMP PREEMPT Mon Mar 31 13:41:48 CEST 2014
>
>
> Seems like an logic error.
>
> How to get out of there?
>
>
> Thanks,
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
