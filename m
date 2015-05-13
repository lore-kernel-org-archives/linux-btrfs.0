Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:37652 "EHLO
	techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965109AbbEMPwJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 11:52:09 -0400
Message-ID: <5553731B.9020200@techsquare.com>
Date: Wed, 13 May 2015 11:51:55 -0400
From: Matt McKinnon <matt@techsquare.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
References: <55512147.5030708@techsquare.com>  <20150511234604.GF15670@merlins.org>  <55515093.4060504@techsquare.com> <20150512144141.GG15670@merlins.org> (sfid-20150512_104155_536751_2B218AE4)
In-Reply-To: <20150512144141.GG15670@merlins.org> (sfid-20150512_104155_536751_2B218AE4)
Content-Type: text/plain; charset=windows-1252; format=flowed
Subject: Re: btrfs send/receive error
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/12/2015 10:41 AM, Marc MERLIN wrote:
> On Mon, May 11, 2015 at 09:00:03PM -0400, Matt McKinnon wrote:
>>> Marc
>>
>> Send box is 3.16.6 .  Receive box is 3.17.4 .
>>
>> Just upgraded the receiving box to 4.0.2 which didn't fix it, so
>> I'll schedule a reboot of the sending box.
>
> Yeah, usually these problems are because the sender sent a sequence of
> events that doesn't make sense and can't be replicated by the receiver.
> Hopefully the server upgrade will fix it.
>
> Otherwise Filipe will be very interested in getting the output of btrfs
> send -v -v from the sending and receiving side just around the time
> where it dies.
>
> Marc
>

The kernel upgrade on both ends fixed it.  Thanks Marc, Filipe.

-Matt
