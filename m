Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:10883 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753354Ab3I0Tb2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 15:31:28 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: csum questions
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130927191315.GY30372@lenny.home.zabbo.net>
Date: Fri, 27 Sep 2013 13:31:24 -0600
Cc: Hugo Mills <hugo@carfax.org.uk>, Tom Gundersen <teg@jklm.no>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <8BDB8494-7A9B-43A9-AF55-0415566BAEF4@colorremedies.com>
References: <CAG-2HqV3MoRQ9E9VqjJ7NFKia7=b30_LKKL82FmV6s4u6vOrTA@mail.gmail.com> <20130927142535.GB28147@carfax.org.uk> <20130927175150.GU30372@lenny.home.zabbo.net> <3A64B568-616C-438A-A634-450F4514C861@colorremedies.com> <20130927191315.GY30372@lenny.home.zabbo.net>
To: Zach Brown <zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 27, 2013, at 1:13 PM, Zach Brown <zab@redhat.com> wrote:

> On Fri, Sep 27, 2013 at 12:47:57PM -0600, Chris Murphy wrote:
>> 
>> On Sep 27, 2013, at 11:51 AM, Zach Brown <zab@redhat.com> wrote:
>> 
>>>>> 2) How may I tell btrfs to ignore all csums and just assume they are
>>>>> all correct? The reason for wanting this is in case the csum is
>>>>> garbled and the file is intact, or the csum is correct and the file is
>>>>> only partially garbled, but may still contain useful data.
>>>> 
>>>>  You can't, right now. There's discussion on IRC about this very
>>>> point right now. :)
>>> 
>>> Well, hold on.  Yes, you can't tell it to just not check checksums.
>>> 
>>> But keep reading.  It sounds like he thinks that *any* reads to the file
>>> will error once any checksum has failed.  Surely that's not true, you
>>> can do use like dd conv=noerror and read all the extents of the file
>>> whose checksums are still valid.
>> 
>> Would that get me an identically sized copy of the file, such as it is?
> 
> As far as I know, yes.

OK this part of what you said made my eyebrows raise: "read all the extents of the file whose checksums are still valid" because it implied that extents with invalid checksums aren't read. And that would be a much bigger problem than the original corruption.


Chris Murphy