Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34620 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417Ab3EWQaJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 May 2013 12:30:09 -0400
Message-ID: <519E440F.2060405@itwm.fraunhofer.de>
Date: Thu, 23 May 2013 18:30:07 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
To: Bob Marley <bobmarley@shiftmail.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: raid6: rmw writes all the time?
References: <knl3ke$n7t$1@ger.gmane.org> <20130523131118.4907.45217@localhost.localdomain> <519E1821.5070507@itwm.fraunhofer.de> <519E1C95.4030501@shiftmail.org>
In-Reply-To: <519E1C95.4030501@shiftmail.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/23/2013 03:41 PM, Bob Marley wrote:
> On 23/05/2013 15:22, Bernd Schubert wrote:
>>
>> Yeah, I know and I'm using iostat already. md raid6 does not do rmw,
>> but does not fill the device queue, afaik it flushes the underlying
>> devices quickly as it does not have barrier support - that is another
>> topic, but was the reason why I started to test btrfs.
> 
> MD raid6 DOES have barrier support!
> 

For underlying devices yes, but it does not further use it for
additional buffering.
