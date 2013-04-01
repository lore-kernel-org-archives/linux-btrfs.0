Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:34595 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab3DANpQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2013 09:45:16 -0400
Received: by mail-oa0-f54.google.com with SMTP id n12so1974879oag.27
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Apr 2013 06:45:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130401133110.GH1876@localhost.localdomain>
References: <20130401041540.4b8a4ab3@natsu>
	<20130401043605.2eb250a7@natsu>
	<20130401141207.533886a2@natsu>
	<20130401133110.GH1876@localhost.localdomain>
Date: Mon, 1 Apr 2013 06:45:16 -0700
Message-ID: <CAOOVQYKDyFXJPKFR-b20cMR6dWOW9MMu2Buk5644ig_45qvDWA@mail.gmail.com>
Subject: Re: BTRFS error in __btrfs_inc_extent_ref:1935: Object already exists
From: Chris Kastorff <encryptio@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Roman Mamedov <rm@romanrm.ru>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a (larger, 7x2TB at RAID10) filesystem that was recently hit by
this. Same story; filesystem works normally, balance start, works for
a while, then fails with similar stack traces and remounts read-only,
after a reboot does not mount at all with similar error messages and
stack traces.

The FS is still in that state. I'll grab an image and mail a link
privately. I don't need to do anything special for btrfs-image on a
multi-device fs, right?

Kernel version is 3.8.4-1-ARCH (archlinux.)

On Mon, Apr 1, 2013 at 6:31 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Mon, Apr 01, 2013 at 02:12:07AM -0600, Roman Mamedov wrote:
>> On Mon, 1 Apr 2013 04:36:05 +0600
>> Roman Mamedov <rm@romanrm.ru> wrote:
>>
>> > Hello,
>> >
>> > After a reboot the filesystem now does not mount at all, with similar messages.
>>
>> So thinking this was an isolated incident, I foolishly continued setting up
>> scheduled balance on other systems with btrfs that I have.
>>
>> And got into exactly the same situation on another machine!!
>>
>> Trying to balance this with -dusage=5, on kernel 3.8.5:
>>
>> Data: total=215.01GB, used=141.76GB
>> System, DUP: total=32.00MB, used=32.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, DUP: total=9.38GB, used=1.09GB
>>
>> Same messages, "Object already exists".
>>
>> While I currently left the previously mentioned 2TB FS in an unmounted broken
>> state, still waiting for any response from you on how to properly recover from
>> this problem, in this new case I needed to restore the machine as soon as
>> possible.
>>
>> I tried btrfsck --repair, it corrected a lot of errors, but in the end gave up
>> with a message saying that it can't repair the filesystem; then I did
>> btrfs-zero-log. After this the FS started mounting successfully again.
>>
>> Not sure if I got any data corruption as a result, but this is the root FS
>> and /home, and the machine successfully booted up with no data lost in any of
>> the apps that were active just before the crash (e.g browser, IM and IRC
>> clients), so probably not.
>>
>
> Can you capture an image of these broken file systems the next time it happens?
> You'll need to clone the progs here
>
> git://github.com/josefbacik/btrfs-progs.git
>
> and build and then run
>
> btrfs-image -w /dev/whatever blah.img
>
> and then upload blah.img up somewhere I can pull it down.  You can use the -t
> and -c options too, but the -w is the most important since you have extent tree
> corruption.  Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
