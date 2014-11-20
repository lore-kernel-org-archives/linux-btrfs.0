Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-03v.sys.comcast.net ([69.252.207.35]:42309 "EHLO
	resqmta-ch2-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757388AbaKTXIM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 18:08:12 -0500
Message-ID: <546E7458.9040302@pobox.com>
Date: Thu, 20 Nov 2014 15:08:08 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Phillip Susi <psusi@ubuntu.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com> <pan$7c051$a7c25939$cafa59e$f63379c9@cox.net> <546CC04F.6040207@ubuntu.com> <546D0609.9040105@pobox.com> <546D0FEA.5000608@ubuntu.com> <546D1AD3.2010206@pobox.com> <546E5066.1040107@ubuntu.com>
In-Reply-To: <546E5066.1040107@ubuntu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/20/2014 12:34 PM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 11/19/2014 5:33 PM, Robert White wrote:
>>> That would be fake raid, not hardware raid.
>>
>> The LSI MegaRaid controller people would _love_ to hear more about
>> your insight into how their battery-backed multi-drive RAID
>> controller is "fake". You should go work for them. Try the "contact
>> us" link at the bottom of this page. I'm sure they are waiting for
>> your insight with baited breath!
>
> Forgive me, I should have trimmed the quote a bit more.  I was
> responding specifically to the "many mother boards have hardware RAID
> support available through the bios" part, not the lsi part.

Well you should have _actually_ trimmed your response down to not 
pressing send.

_Many_ motherboards have complete RAID support at levels 0, 1, 10, and 
five 5. A few have RAID6.

Some of them even use the LSI chip-set.

Seriously... are you trolling this list with disinformation or just 
repeating tribal knowledge from fifteen year old copies of PC Magazine?

Yea, some of the IDE motherboards and that only had RAID1 and RAID0 (and 
indeed some of the add-on controllers) back in the IDE-only days were 
really lame just-forked-write devices with no integrity checks (hence 
"fake raid") but that's from like the 1990s; it's paleolithic age 
"wisdom" at this point.

Phillip say sky god angry, all go hide in cave! /D'oh...
