Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39176 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758314Ab3EWTpm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 May 2013 15:45:42 -0400
Message-ID: <519E71E0.2060301@itwm.fraunhofer.de>
Date: Thu, 23 May 2013 21:45:36 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
To: Chris Mason <clmason@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: raid6: rmw writes all the time?
References: <knl3ke$n7t$1@ger.gmane.org> <20130523131118.4907.45217@localhost.localdomain> <519E1821.5070507@itwm.fraunhofer.de> <20130523133418.4907.21116@localhost.localdomain> <519E6F04.5000900@itwm.fraunhofer.de> <20130523193741.4907.41422@localhost.localdomain>
In-Reply-To: <20130523193741.4907.41422@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/23/2013 09:37 PM, Chris Mason wrote:
> Quoting Bernd Schubert (2013-05-23 15:33:24)
>> Btw, any chance to generally use chunksize/chunklen instead of stripe,
>> such as the md layer does it? IMHO it is less confusing to use
>> n-datadisks * chunksize = stripesize.
> 
> Definitely, it will become much more configurable.

Actually I meant in the code. I'm going to write a patch during the weekend.

> 
>>
>>>
>>> Using buffered writes makes it much more likely the VM will break up the
>>> IOs as they go down.  The btrfs writepages code does try to do full
>>> stripe IO, and it also caches stripes as the IO goes down.  But for
>>> buffered IO it is surprisingly hard to get a 100% hit rate on full
>>> stripe IO at larger stripe sizes.
>>
>> I have not found that part yet, somehow it looks like as if writepages
>> would submit single pages to another layer. I'm going to look into it
>> again during the weekend. I can reserve the hardware that long, but I
>> think we first need to fix striped writes in general.
> 
> The VM calls writepages and btrfs tries to suck down all the pages that
> belong to the same extent.  And we try to allocate the extents on
> boundaries.  There is definitely some bleeding into rmw when I do it
> here, but overall it does well.
> 
> But I was using 8 drives.  I'll try with 12.

Hmm, I already tried with 10 drives (8+2), doesn't make a difference for
RMW.

> 
>> Direct-io works as expected and without any RMW cycles. And that
>> provides more than 40% better performance than the Megasas controller or
>> buffered MD writes (I didn't compare with direct-io MD, as that is very
>> slow).
> 
> You can improve MD performance quite a lot by increasing the size of the
> stripe cache.

I'm already doing that, without a higher stripe cache the performance is
much lower.

