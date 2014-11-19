Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:40487 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933511AbaKSWd7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 17:33:59 -0500
Message-ID: <546D1AD3.2010206@pobox.com>
Date: Wed, 19 Nov 2014 14:33:55 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Phillip Susi <psusi@ubuntu.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com> <pan$7c051$a7c25939$cafa59e$f63379c9@cox.net> <546CC04F.6040207@ubuntu.com> <546D0609.9040105@pobox.com> <546D0FEA.5000608@ubuntu.com>
In-Reply-To: <546D0FEA.5000608@ubuntu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

P.S.

On 11/19/2014 01:47 PM, Phillip Susi wrote:
>> Another common cause is having a dedicated hardware RAID
>> controller (dell likes to put LSI MegaRaid controllers in their
>> boxes for example), many mother boards have hardware RAID support
>> available through the bios, etc, leaving that feature active, then
>> the adding a drive and
>
> That would be fake raid, not hardware raid.

The LSI MegaRaid controller people would _love_ to hear more about your 
insight into how their battery-backed multi-drive RAID controller is 
"fake". You should go work for them. Try the "contact us" link at the 
bottom of this page. I'm sure they are waiting for your insight with 
baited breath!

http://www.lsi.com/products/raid-controllers/pages/megaraid-sas-9260-8i.aspx

>> _not_ initializing that drive with the RAID controller disk setup.
>> In this case the controller is going to repeatedly probe the drive
>> for its proprietary controller signature blocks (and reset the
>> drive after each attempt) and then finally fall back to raw block
>> pass-through. This can take a long time (thirty seconds to a
>> minute).
>
> No, no, and no.  If it reads the drive and does not find its metadata,
> it falls back to pass through.  The actual read takes only
> milliseconds, though it may have to wait a few seconds for the drive
> to spin up.  There is no reason it would keep retrying after a
> successful read.

Odd, my MegaRaid controller takes about fifteen seconds by-the-clock to 
initialize and to the integrity check on my single initialized drive. 
It's amazing that with a fail and retry it would be _faster_...

It's like you know _everything_...


