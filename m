Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:57980 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753045AbaLGToH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 14:44:07 -0500
Message-ID: <f93aee6392f64cc092304699c250cd59.squirrel@webmail.wanet.net>
In-Reply-To: <2268945.SsYGbSXAx5@merkaba>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
    <44320137.fRRuR6EFMP@merkaba>
    <88937b9f24bc72160d80977c9edefba2.squirrel@webmail.wanet.net>
    <2268945.SsYGbSXAx5@merkaba>
Date: Sun, 7 Dec 2014 11:44:06 -0800
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
From: ashford@whisperpc.com
To: "Martin Steigerwald" <Martin@lichtvoll.de>
Cc: ashford@whisperpc.com, "Shriramana Sharma" <samjnaa@gmail.com>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Am Sonntag, 7. Dezember 2014, 10:20:27 schrieb ashford@whisperpc.com:
>> Martin,
>>
>> > I read that the actual
>> > what is free is unknown. And there are several reasons for that:
>> >
>> > 1) On a compressed filesystem you cannot know, but only estimate the
>> > compression ratio for future data.
>>
>> It is NOT the job of BTRFS, or ANY file-system, to try to prodict the
>> future.  The future is unknown.  Don't try to account for it.  When
>> asked
>> for the status (i.e. 'df'), it should return the current status.
>>
>> > 2) On a compressed filesystem you can choose to have parts of it
>> > uncompressed by file / directory attributes, I think. BTRFS can't
>> > know how much of the
>> > future data you are going to store compressed or uncompressed.
>>
>> Same as above.
>
> What is the point you are trying to make?
>
> I just described the reasons on what problems there are with trying to
> predict
> available free space, with BTRFS as an example. Some points apply to all
> filesystems, some do not, so what is the point you are trying to make?

My point is that you don't try to predict, as that's a guaranteed path to
failure.  You deliver what you know.  This is what every other file-system
does.  There's no reason to do anything else.

Peter Ashford

