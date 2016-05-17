Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35301 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbcEQL0W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 07:26:22 -0400
Received: by mail-ig0-f178.google.com with SMTP id bi2so71732959igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 04:26:22 -0700 (PDT)
Subject: Re: BTRFS Data at Rest File Corruption
To: Chris Murphy <lists@colorremedies.com>,
        "Richard A. Lochner" <lochner@clone1.com>
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
 <97b8a0bd-3707-c7d6-4138-c8fe81937b72@gmail.com>
 <1463075341.3636.56.camel@clone1.com>
 <CAJCQCtSSbv5dAC-uBN9RnYKKRMtr04KmLZVzhvAh7=Xq3ej7dQ@mail.gmail.com>
 <1463114957.3636.140.camel@clone1.com>
 <CAJCQCtSNwpaPs6jWFxzoHdUFJUyUZFjX6vocYf7RCWc=f_n5Hg@mail.gmail.com>
 <1463337834.4626.14.camel@clone1.com>
 <CAJCQCtSYgfhmNYFE4ffxFy20B=trkh+P=hhdbrq71ysZSm_FEA@mail.gmail.com>
 <41b097af-d565-6cd7-2ed8-cb66b9ae8ecc@gmail.com>
 <CAJCQCtSmmm-2aCUQvG4QNYvLHCo0LPcYKbSkmcxE1m5JqTL9zQ@mail.gmail.com>
 <1463442292.3278.61.camel@clone1.com>
 <CAJCQCtQE4apgSw+5mX+4h050opH1Jw3MYXk5jUfab1DzS1f-+Q@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <835ec53d-cb4e-5a7a-289a-8fe89c08851f@gmail.com>
Date: Tue, 17 May 2016 07:26:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQE4apgSw+5mX+4h050opH1Jw3MYXk5jUfab1DzS1f-+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-16 23:42, Chris Murphy wrote:
> On Mon, May 16, 2016 at 5:44 PM, Richard A. Lochner <lochner@clone1.com> wrote:
>> Chris,
>>
>> It has actually happened to me three times that I know of in ~7mos.,
>> but your point about the "larger footprint" for data corruption is a
>> good one.  No doubt I have silently experienced that too.
>
> I dunno three is a lot to have the exact same corruption only in
> memory then written out into two copies with valid node checksums; and
> yet not have other problems, like a node item, or uuid, or xattr or
> any number of other item or object types all of which get checksummed.
> I suppose if the file system contains large files, the % of metadata
> that's csums could be the 2nd largest footprint. But still.
Assuming that the workload on the volume is mostly backup images like 
the file that originally sparked this discussion, then inodes, xattrs, 
and even UUID's would be nowhere near as common as metadata blocks just 
containing checksums.  The fact that this hasn't hit any metadata 
checksums is unusual, but not impossible.
>
> Three times in 7 months, if it's really the same vector, is just short
> of almost reproducible. Ha. It seems like if you merely balanced this
> file system a few times, you'd eventually stumble on this. And if
> that's true, then it's time for debug options and see if it can be
> caught in action, and whether there's a hardware or software
> explanation for it.
>
>
>> And, as you
>> suggest, there is no way to prevent those errors.  If the memory to be
>> written to disk gets corrupted before its checksum is calculated, the
>> data will be silently corrupted, period.
>
> Well, no way in the present design, maybe.
If the RAM is bad, there is no way we can completely protect user data, 
period.  We can try to mitigate certain situations, but we cannot 
protect against all forms of memory corruption.
>
>>
>> Clearly, I won't rely on this machine to produce any data directly that
>> I would consider important at this point.
>>
>> One odd thing to me is that if this is really due to undetected memory
>> errors, I'd think this system would crash fairly often due to detected
>> "parity errors."  This system rarely crashes.  It often runs for
>> several months without an indication of problems.
>
> I think you'd have other problems. Only data csums are being corrupt
> after they're read in, but before the node csum is computed? Three
> times?  Pretty wonky.
Running regularly for several months without ECC RAM may be part of the 
issue.  Minute electrical instabilities build up over time, as do 
instabilities caused by background radiation, and beyond a certain point 
(which is based on more factors than are practical to compute), you end 
up almost certain to have at least a single bit error.

On that note, I'd actually be curious to see how far off the checksum is 
(how many bits aren't correct).  Given that there are no other visible 
issues with the system, I'd expect it to only be one or at most two bits 
that are incorrect.

