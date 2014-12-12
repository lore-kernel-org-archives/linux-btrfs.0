Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:42601 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967589AbaLLNcX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 08:32:23 -0500
Message-ID: <548AEE63.4010006@pobox.com>
Date: Fri, 12 Dec 2014 05:32:19 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Erkki Seppala <flux-btrfs@inside.org>, linux-btrfs@vger.kernel.org
Subject: Re: Balance & scrub & defrag
References: <CAAe=sHWSR=G0+hJCbLCQfgBB_b9VQxu2Q8JETMuRgz79fcBUbg@mail.gmail.com>	<5488F0A8.7070503@pobox.com>	<44336672.dmUL7ANCyf@russell.coker.com.au>	<548A4560.9010105@pobox.com> <m49egs5b515.fsf@coffee.modeemi.fi>
In-Reply-To: <m49egs5b515.fsf@coffee.modeemi.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/12/2014 01:17 AM, Erkki Seppala wrote:
> Robert White <rwhite@pobox.com> writes:
>
>> You need to buy better disks. 8-)
>
> Where can one buy these better disks with reasonable prices?-) Disks are
> best thought of as consumables.

A good disk is only about 9% more expensive. So like the WD "green" 
disks were all cheap because they were (essentially) the disks that 
didn't pass the full quality suite for the higher WD lines like "caviar".

"Inexpensive" and "Cheap" are not the same thing.

Disks are not best thought of as consumables unless the data you store 
on them is discardable.

> Do you alternatively execute SMART self tests?

Indeed. If you install and activate SMART but you never run the tests 
you've done another one of those half-measures I was talking about.

The "long offline" test reads 100% of the disk surface (well, up until 
it hits an error anyway). But since none of that data has to leave the 
disk controller and go out through the interface etc it doesn't bog the 
rest of the system.

All but the oldest or cheapest drives have controllers that will "resume 
the offline test after any command" so you do

smartctl --test=long /dev/sda # or whatever

every few days and you'll know when things start to get dicy.

The one thing you do have to be watchful of is that the tests _stop_ 
when they hit the first read error, so you do have to keep up with things.

For instance I just had a pair of uncorrectable read errors. When I used 
hdparm to write the sectors, however, the disk didn't need to relocate 
the block(s) as bad. So it was some funky event on the disk itself.

Of course it's a very old disk (1525 days of power-on runtime) so two 
correctable-with-overwrite read errors isn't bad.


