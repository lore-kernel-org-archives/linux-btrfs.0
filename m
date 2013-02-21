Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:39705 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab3BUJZX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 04:25:23 -0500
Received: by mail-ea0-f171.google.com with SMTP id c13so3916989eaa.16
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 01:25:21 -0800 (PST)
Message-ID: <5125E7FB.6020502@bjorling.me>
Date: Thu, 21 Feb 2013 10:25:15 +0100
From: =?ISO-8859-1?Q?Matias_Bj=F8rling?= <m@bjorling.me>
MIME-Version: 1.0
To: Alex Elsayed <eternaleye@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Hybrid Storage proposal
References: <20130220164605.GA13504@uflip.org> <kg37js$5vc$1@ger.gmane.org>
In-Reply-To: <kg37js$5vc$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/20/2013 08:19 PM, Alex Elsayed wrote:
> Matias Bjorling wrote:
>
>> Here is a short proposal for the hybrid storage cache idea with
>> introduction/motivation and a bird's eye view of an approach to implement
>> a hybrid storage cache for btrfs. Please note that there is currently no
>> available patches. We would like to get as much input before as possible
>> before we start designing and implementing a solution.
>
> Just to toss this out there, aside from the option of 'cache chunks' there
> is the option of using normal chunks, and instead place extents on chunks
> based on performance characteristics of the underlying device.
>
> As an analogy, if the above proposal is closer to the 'bcache' approach of
> treating the SSD purely as a performance enhancer that does not contribute
> to capacity, performance-based allocation is closer to the 'btier' [1]
> approach in which the SSD does contribute to capacity, but has 'dibs' on
> performance-sensitive data.
>
> [1] Btier sourceforge page: http://sourceforge.net/projects/tier/
>
> Lessfs homepage, with btier info: http://www.lessfs.com/wordpress/

Good point. I think both approaches are relatively easy to combine.
