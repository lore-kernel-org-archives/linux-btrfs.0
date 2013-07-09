Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [85.19.192.18] ([85.19.192.18]:32911 "EHLO mail.itpas.no"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751070Ab3GIEYx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jul 2013 00:24:53 -0400
Message-ID: <51DB8E78.1080604@itpas.no>
Date: Tue, 09 Jul 2013 06:15:52 +0200
From: =?ISO-8859-1?Q?Torbj=F8rn_Skagestad?= <torbjorn@itpas.no>
MIME-Version: 1.0
To: dsterba@suse.cz, =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>,
        linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: Scrub causes oom after removal of failed disk (linux 3.10)
References: <51D46F04.6010301@skagestad.org> <20130708213627.GG18204@twin.jikos.cz>
In-Reply-To: <20130708213627.GG18204@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/08/2013 11:36 PM, David Sterba wrote:
> On Wed, Jul 03, 2013 at 08:35:48PM +0200, Torbjørn wrote:
>> Hi btrfs devs,
>>
>> I have a btrfs raid10 array consisting of 2TB drives.
>>
>> I added a new drive to the array, then balanced.
>> The balance failed after ~50GB was moved to the new drive.
>> The balance fixed lots of errors according to dmesg.
>>
>> Server rebooted
>>
>> The newly added drive were no longer detected as a btrfs disk.
>> The array was then mounted -o recovery
>> I ran btrfs dev del missing, and everything seemed to be fine.
>>
>> After this I ran a scrub on the array.
>> The scrub was soon stopped by the oom-killer.
>>
>> After another reboot I started a new scrub.
>> About 3TB into the scrub over 10 GB of memory was being consumed.
>> The scrub had then fixed roughly 3,000,000 errors.
>>
>> Canceling the scrub and resuming it frees the 10 GB of memory.
> Thanks for the report.
>
> This looks like the same problem that was fixed by
> https://patchwork.kernel.org/patch/2697501/
> Btrfs: free csums when we're done scrubbing an extent
>
> but I don't see it included in the current for-linus branch. We want
> this in the 3.10.x stable series and according to stable tree policy it
> has to be merged into Linus' tree first.
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Ok, thanks

--
Torbjørn
