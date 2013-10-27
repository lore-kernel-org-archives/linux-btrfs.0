Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw12a-194.wadns.net ([196.220.39.194]:24787 "EHLO
	fw12a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752672Ab3J0Vem (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Oct 2013 17:34:42 -0400
Message-ID: <526D86DE.6070603@swiftspirit.co.za>
Date: Sun, 27 Oct 2013 23:34:22 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Lester B <b.lester011+btrfs@gmail.com>, linux-btrfs@vger.kernel.org
CC: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Total fs size does not match with the actual size of the setup
References: <CAOeUAF_msDRoi2CDnAhwqC+=_oqNqH0=94+N9qjXpi4m4ChVLg@mail.gmail.com>	<20131027201750.GG31029@carfax.org.uk> <CAOeUAF9FWCMwktn-nZR6wn+RiKHf9Qy_Yk7maqy0LzP8iQ6X6Q@mail.gmail.com>
In-Reply-To: <CAOeUAF9FWCMwktn-nZR6wn+RiKHf9Qy_Yk7maqy0LzP8iQ6X6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/10/27 10:27 PM, Lester B wrote:
> 2013/10/28 Hugo Mills <hugo@carfax.org.uk>:
>> On Mon, Oct 28, 2013 at 04:09:18AM +0800, Lester B wrote:
>>> The btrfs setup only have one device of size 7 GiB but
>>> when I run df, the total size shown is 15 GiB. Running
>>> btrfs --repair
>>     I'd recommend not running btrfs check --repair unless you really
>> know what you're doing, or you've checked with someone knowledgable
>> and they say you should try it. On a non-broken filesystem (as here),
>> it's probably OK, though.
>>
>>> displays an error "cache and super
>>> generation don't match, space cache will be invalidated."
>>     This is harmless.
>>
>>> How can I correct the total fs size as shown in df?
>>     You can't. It's an artefact of the fact that you've got a RAID-1
>> (or RAID-10, or --mixed and DUP) filesystem, and that the standard
>> kernel interface for df doesn't allow us to report the correct figures
>> -- see [1] (and the subsequent entry as well) for a more detailed
>> description.
>>
>>     Hugo.
>>
>> [1] https://btrfs.wiki.kernel.org/index.php/FAQ#Why_does_df_show_incorrect_free_space_for_my_RAID_volume.3F
>>
>> --
>> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>>    PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>>           --- Nothing right in my left brain. Nothing left in ---
>>                               my right brain.
>
> But my setup is a simple one without any RAID levels or other things so at least
> df size column should show the actual size of my setup.
Could you send us the output of the following?:
  btrfs fi df <mountpoint>
(where <mountpoint> is the path where the btrfs is mounted.)

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

