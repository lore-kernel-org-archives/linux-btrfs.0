Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw7a.wadns.net ([196.220.39.49]:32280 "EHLO fw7a.wadns.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672Ab3J0VQT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Oct 2013 17:16:19 -0400
Message-ID: <526D8293.3030501@swiftspirit.co.za>
Date: Sun, 27 Oct 2013 23:16:03 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Hans-Kristian Bakke <hkbakke@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Non-intelligent behaviour on device delete with multiple devices?
References: <CAD_cGvGG9KPastZr1QCE_d0rmR=saj9Drj25hAzSzRkg6oEL2g@mail.gmail.com>
In-Reply-To: <CAD_cGvGG9KPastZr1QCE_d0rmR=saj9Drj25hAzSzRkg6oEL2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/10/27 07:33 PM, Hans-Kristian Bakke wrote:
> Hi
>
> Today I tried removing two devices from a multidevice btrfs RAID10
> volume using the following command:
> ---
> btrfs device delete /dev/sdl /dev/sdk /btrfs
> ---
>
> It first removed device sdl and then sdk. What I did not expect
> however was that btrfs didn't remove sdk from the available drives
> when removing and rebalancing data from the first device. This
> resultated in that over 300GB of data was actually added to sdk during
> removal of sdl, only to make the removal process of sdk longer.
>
> This seems to me as a rather non-intelligent way to do this. I would
> expect that all drives given as input to the btrfs device delete
> command was removed from the list of drives available for rebalancing
> of the data during removal of the drives.
This is a known issue I'm sure will be addressed. It has annoyed me in 
the past as well. Perhaps add it to the wiki: 
https://btrfs.wiki.kernel.org/index.php/Project_ideas

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

