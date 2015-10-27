Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33345 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbbJ0RJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 13:09:03 -0400
Received: by igbkq10 with SMTP id kq10so99807056igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 10:09:02 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <40k4gc-scp.ln1@aldebaran.xundeenergie.at>
References: <c76lfc-jfl.ln1@aldebaran.xundeenergie.at>
	<CAM9fjH4vQki-0UjdMTGZgKEbDy1pRBZNRqro8TtqzLbDPwfsvw@mail.gmail.com>
	<40k4gc-scp.ln1@aldebaran.xundeenergie.at>
Date: Tue, 27 Oct 2015 17:09:02 +0000
Message-ID: <CAL3q7H7YteBC_jFNRQxZsWmw9TamEskXpY7NJAbMfcpGhYnoHg@mail.gmail.com>
Subject: Re: btrfs-balance causes system-freeze on full disk
From: Filipe Manana <fdmanana@gmail.com>
To: =?UTF-8?Q?Jakob_Sch=C3=BCrz?= <wertstoffe@nurfuerspam.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 27, 2015 at 4:05 PM, Jakob Schürz <wertstoffe@nurfuerspam.de> wrote:
> Found a new habit...
>
> I have a lot Snapshots on my drive. (Take every 10 Min a new one, every
> houry one, every day one, every system-update, every plugin after
> external HD...)
>
> If there are to much snapshots (didn't find out the count how much
> exactly) balancing fails with a system-freeze.
> if i delete some of my snapshots, balancing is working...
>
> Maybe this is a hint for bugfixing!!

A patch set to fix this issue was already sent yesterday and tested
over the weekend by Stéphane:

http://thread.gmane.org/gmane.comp.file-systems.btrfs/49630

cheers

>
> Do you think?
>
> greez
>
> Jakob
>
> Am 2015-10-21 um 22:51 schrieb Kyle Manna:
>> I had a number of similar btrfs balance crashes in the past few days,
>> but the disk wasn't full.  You should try tailing the system logs from
>> a remote machine when it happens. You'll likely see some bug info
>> before the system dies and becomes unusable.
>>
>> The issue I encountered is described @
>> https://bugzilla.kernel.org/show_bug.cgi?id=105681
>> ᐧ
>>
>> On Wed, Oct 21, 2015 at 12:38 PM, Jakob Schürz
>> <wertstoffe@nurfuerspam.de> wrote:
>>> Hi there!
>>>
>>> Is it possible, what i've recognized now. My system (debian) runs on
>>> btrfs, and i have a lot of snapshots on my hard-disk.
>>> Since some days my system freezes totally. I recognized, it always
>>> happens during btrfs-balance.
>>>
>>> So i deleted some of the old snapshots and tried another balance-run.
>>> Nothing happened... No system-freeze.
>>>
>>> System-freeze means: No Keyboard-action. The Mouse is frozen, the screen
>>> is frozen, no magic-sysreq, no ssh-login.
>>>
>>> Can btrfs cause such a freeze??
>>>
>>> greez
>>>
>>> jakob
>>> --
>>> http://xundeenergie.at
>>> http://verkehrsloesungen.wordpress.com/
>>> http://cogitationum.wordpress.com/
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> http://xundeenergie.at
> http://verkehrsloesungen.wordpress.com/
> http://cogitationum.wordpress.com/
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
