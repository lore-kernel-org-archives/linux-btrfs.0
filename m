Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:27140 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752780Ab3IAADI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Aug 2013 20:03:08 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Device delete returns "unable to go below four devices on raid10" on 5 drive setup
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1377993349.5004.38.camel@pc-steven.LAN>
Date: Sat, 31 Aug 2013 18:03:05 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <6E2BF7E8-C893-4B6D-9B50-27434BEABD78@colorremedies.com>
References: <1377943975.5426.17.camel@pc-steven.LAN> <A4758013-22BA-4552-B391-9492B42D85C5@colorremedies.com> <1377993349.5004.38.camel@pc-steven.LAN>
To: Steven Post <redalert.commander@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 31, 2013, at 5:55 PM, Steven Post <redalert.commander@gmail.com> wrote:

> On Sat, 2013-08-31 at 11:42 -0600, Chris Murphy wrote:
>> 
>> Yes. It might take a few minutes after the chunks are reallocated for the device to be removed from the volume. I've had some cases where even a reboot was needed for the information in fi sh to refresh.
> 
> I see, so that might be normal behaviour.

No, I think it's expected for deleted devices to not appear in the volume listing anymore, but with older kernels I had that experience. I haven't tried it recently with newer kernels.

> 
> As an aside, I'd rather not recreate the arrays if it can be done
> without recreating.

It should work. But it's an experimental file system. I'd at least make a backup if you're going to do this with the device add/remove method.


Chris Murphy