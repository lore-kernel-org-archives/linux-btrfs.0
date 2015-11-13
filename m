Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:35599 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbbKMUS3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 15:18:29 -0500
Received: by lbbsy6 with SMTP id sy6so31612514lbb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 12:18:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHTEL3n3G-fz6wFZhODhSiCznokhJCTD3PU9fmeumb19kyos_Q@mail.gmail.com>
References: <CAHTEL3=r8kUJOU=xUAg2iG52HuWmqQ16QxUjY6d+zqbziW5+gw@mail.gmail.com>
	<564486F3.5020804@gmail.com>
	<CAHTEL3mEGmc5BhbGMEAbyPNU90nFQGZprLkWrh1WaEh5sSiH8w@mail.gmail.com>
	<56461034.3070209@gmail.com>
	<CAHTEL3m0uGWZGWUH_SLmg8TqMe4DcXU77p+S=4Aebukr1BZ-Bg@mail.gmail.com>
	<56462784.2060601@gmail.com>
	<20151113184227.GF24333@carfax.org.uk>
	<CAHTEL3n3G-fz6wFZhODhSiCznokhJCTD3PU9fmeumb19kyos_Q@mail.gmail.com>
Date: Fri, 13 Nov 2015 21:18:27 +0100
Message-ID: <CAHTEL3nxhfvpLp_jOvioe4ubjTSCBk2=Cn2+9wmi=e=ErnhWeA@mail.gmail.com>
Subject: Re: illegal snapshot, cannot be deleted
From: Vedran Vucic <vedran.vucic@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Vedran Vucic <vedran.vucic@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

My system is on laptop that is not heavy duty such as servers.
openSuse 13.2 was installed approx 2 months ago so the issue did not
appear due to longterm lack of administration or maintenance.
Please let me know if I can help in any other way.

Thanks,

vedran

On Fri, Nov 13, 2015 at 9:15 PM, Vedran Vucic <vedran.vucic@gmail.com> wrote:
> Hello,
>
> I guess that it might be bug in kernel.
> I was successful this:
> btrfs balance start / -dusage=50 -musage=35
>
> musage above 35 caused ENOSPC message. Otherwise it was good.
> Thanks on support,
>
> vedran
>
> On Fri, Nov 13, 2015 at 7:42 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Fri, Nov 13, 2015 at 01:10:12PM -0500, Austin S Hemmelgarn wrote:
>>> On 2015-11-13 12:30, Vedran Vucic wrote:
>>> >Hello,
>>> >
>>> >Here are outputs of commands as you requested:
>>> >  btrfs fi df /
>>> >Data, single: total=8.00GiB, used=7.71GiB
>>> >System, DUP: total=32.00MiB, used=16.00KiB
>>> >Metadata, DUP: total=1.12GiB, used=377.25MiB
>>> >GlobalReserve, single: total=128.00MiB, used=0.00B
>>> >
>>> >btrfs fi show
>>> >Label: none  uuid: d6934db3-3ac9-49d0-83db-287be7b995a5
>>> >         Total devices 1 FS bytes used 8.08GiB
>>> >         devid    1 size 18.71GiB used 10.31GiB path /dev/sda6
>>> >
>>> >btrfs-progs v4.0+20150429
>>> >
>>> Hmm, that's odd, based on these numbers, you should be having no
>>> issue at all trying to run a balance. You might be hitting some
>>> other bug in the kernel, however, but I don't remember if there were
>>> any known bugs related to ENOSPC or balance in the version you're
>>> running.
>>
>>    There's one specific bug that shows up with ENOSPC exactly like
>> this. It's in all versions of the kernel, there's no known solution,
>> and no guaranteed mitigation strategy, I'm afraid. Various things like
>> balancing, or adding, balancing, and removing a device again have been
>> tried. Sometimes they seem to help; sometimes they just make the
>> problem worse.
>>
>>    We average maybe one report a week or so(*) with this particular
>> set of symptoms.
>>
>>    Hugo.
>>
>> (*) <waves hands vaguely>
>>
>>>  You might see if trying to re-run the balance with
>>> '-dusage=40 -musage=40' works correctly (I've seen cases where the
>>> first run fails, but subsequent ones work because the first one made
>>> some progress despite failing).
>>> >On Fri, Nov 13, 2015 at 5:30 PM, Austin S Hemmelgarn
>>> ><ahferroin7@gmail.com> wrote:
>>> >>On 2015-11-13 11:12, Vedran Vucic wrote:
>>> >>>
>>> >>>Hello,
>>> >>>
>>> >>>I succeeded to delete illegal snapshot with command:
>>> >>>btrfs subvolume delete /.snapshots/741/snapshot
>>> >>>When I have done
>>> >>>btrfs balance / -dusage=0 -musage=0
>>> >>>increasing value up to 4o I did not have issues.
>>> >>>But on value 4- for-dusage= and -musage=
>>> >>>I got message that there is no space left on disk.
>>> >>>Do you have any advice how to manage that?
>>> >>
>>> >>
>>> >>Can you post the output of 'btrfs fi df' and 'btrfs fi show' again? Both
>>> >>should have changed after the balance, and I'd need to see what it looks
>>> >>like now to be able to give any reasonable advice.
>>> >>
>>> >>
>>>
>>>
>>
>>
>>
>> --
>> Hugo Mills             | You can play with your friends' privates, but you
>> hugo@... carfax.org.uk | can't play with your friends' childrens' privates.
>> http://carfax.org.uk/  |
>> PGP: E2AB1DE4          |                                       C++ coding rule
