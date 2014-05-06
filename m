Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw11a-maira.wadns.net ([196.220.39.139]:25921 "EHLO
	fw11a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750829AbaEFQar (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 12:30:47 -0400
Message-ID: <53690E27.6090101@swiftspirit.co.za>
Date: Tue, 06 May 2014 18:30:31 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, Calvin Walton <calvin.walton@kepstin.ca>,
        Russell Coker <russell@coker.com.au>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Please review and comment, dealing with btrfs full issues
References: <20140506121937.GD10159@merlins.org>
In-Reply-To: <20140506121937.GD10159@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Marc. Inline below. :)

On 2014/05/06 02:19 PM, Marc MERLIN wrote:
> On Mon, May 05, 2014 at 07:07:29PM +0200, Brendan Hide wrote:
>> "In the case above, because the filesystem is only 55% full, I can
>> ask balance to rewrite all chunks that are more than 55% full:
>>
>> legolas:~# btrfs balance start -dusage=50 /mnt/btrfs_pool1"
>>
>> "-dusage=50" will balance all chunks that are 50% *or less* used,
> Sorry, I actually meant to write 55 there.
>
>> not more. The idea is that full chunks are better left alone while
>> emptyish chunks are bundled together to make new full chunks,
>> leaving big open areas for new chunks. Your process is good however
>> - just the explanation that needs the tweak. :)
> Mmmh, so if I'm 55% full, should I actually use -dusage=45 or 55?

As usual, it depends on what end-result you want. Paranoid rebalancing - 
always ensuring there are as many free chunks as possible - is totally 
unnecessary. There may be more good reasons to rebalance - but I'm only 
aware of two: a) to avoid ENOSPC due to running out of free chunks; and 
b) to change allocation type.

If you want all chunks either full or empty (except for that last chunk 
which will be somewhere inbetween), -dusage=55 will get you 99% there.
>> In your last example, a full rebalance is not necessary. If you want
>> to clear all unnecessary chunks you can run the balance with
>> -dusage=80 (636GB/800GB~=79%). That will cause a rebalance only of
>> the data chunks that are 80% and less used, which would by necessity
>> get about ~160GB worth chunks back out of data and available for
>> re-use.
> So in my case when I hit that case, I had to use dusage=0 to recover.
> Anything above that just didn't work.

I suspect when using more than zero the first chunk it wanted to balance 
wasn't empty - and it had nowhere to put it. Then when you did dusage=0, 
it didn't need a destination for the data. That is actually an 
interesting workaround for that case.
> On Mon, May 05, 2014 at 07:09:22PM +0200, Brendan Hide wrote:
>> Forgot this part: Also in your last example, you used "-dusage=0"
>> and it balanced 91 chunks. That means you had 91 empty or
>> very-close-to-empty chunks. ;)
> Correct. That FS was very mis-balanced.
>
> On Mon, May 05, 2014 at 02:36:09PM -0400, Calvin Walton wrote:
>> The standard response on the mailing list for this issue is to
>> temporarily add an additional device to the filesystem (even e.g. a 4GB
>> USB flash drive is often enough) - this will add space to allocate a few
>> new chunks, allowing the balance to proceed. You can remove the extra
>> device after the balance completes.
> I just added that tip, thank you.
>   
> On Tue, May 06, 2014 at 02:41:16PM +1000, Russell Coker wrote:
>> Recently kernel 3.14 allowed fixing a metadata space error that seemed to be
>> impossible to solve with 3.13.  So it's possible that some of my other
>> problems with a lack of metadata space could have been solved with kernel 3.14
>> too.
> Good point. I added that tip too.
>
> Thanks,
> Marc


-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

