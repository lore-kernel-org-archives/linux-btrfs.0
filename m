Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:48967 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbbANV0B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 16:26:01 -0500
Received: by mail-qa0-f49.google.com with SMTP id v8so8525544qal.8
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Jan 2015 13:26:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPs0BijZX-BcM7uRq58TwSUqsNRqsySXeHYRezgVQcfXw-d22g@mail.gmail.com>
References: <CAPs0BijZX-BcM7uRq58TwSUqsNRqsySXeHYRezgVQcfXw-d22g@mail.gmail.com>
Date: Wed, 14 Jan 2015 16:26:00 -0500
Message-ID: <CAPs0Bij=86RtrvY3MApgxKvUdKe0xanpysguo5quWJCBfGEE3w@mail.gmail.com>
Subject: Re: btrfs scrub status reports not running when it is
From: Sandy McArthur Jr <sandymac@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Okay, different output when the scrub is actually complete:

completed status:

scrub status for 94b3345e-2589-423c-a228-d569bf94ab58
scrub started at Tue Jan 13 01:18:22 2015 and finished after 139459 seconds
total bytes scrubbed: 23.30TiB with 513 errors
error details: verify=19 csum=494
corrected errors: 512, uncorrectable errors: 1, unverified errors: 0


Still, the output when wrapping up is still not intuitive to me:

"scrub started at Tue Jan 13 01:18:22 2015, interrupted after 136982
seconds, not running"


On Wed, Jan 14, 2015 at 4:06 PM, Sandy McArthur Jr <sandymac@gmail.com> wrote:
> Sometimes btrfs scrub status reports that is not running when it still is.
>
> I think this a cosmetic bug. And I believe this is related to the
> scrub completing on some drives before others in a multi-drive btrfs
> filesystem that is not well balanced.
>
> Based on `iostat 1` activity the last drive in the btrfs filesystem
> was still being scrubbed at the time I copied the output below, you
> can see the total bytes scrubbed is increasing despite showing as "not
> running". The last drive being scrubbed was not the device identified
> when you list mount points with `mount`:
>
>
> # date ; echo ; btrfs scrub status /mcmedia/
> Wed Jan 14 15:20:18 EST 2015
>
> scrub status for 94b3345e-2589-423c-a228-d569bf94ab58
> scrub started at Tue Jan 13 01:18:22 2015, interrupted after 136912
> seconds, not running
> total bytes scrubbed: 23.05TiB with 513 errors
> error details: verify=19 csum=494
> corrected errors: 512, uncorrectable errors: 1, unverified errors: 0
>
>
> # date ; echo ; btrfs scrub status /mcmedia/
> Wed Jan 14 15:21:25 EST 2015
>
> scrub status for 94b3345e-2589-423c-a228-d569bf94ab58
> scrub started at Tue Jan 13 01:18:22 2015, interrupted after 136982
> seconds, not running
> total bytes scrubbed: 23.06TiB with 513 errors
> error details: verify=19 csum=494
> corrected errors: 512, uncorrectable errors: 1, unverified errors: 0
>
>
> # uname -a
> Linux mcplex 3.18.2-gentoo #1 SMP Mon Jan 12 10:24:25 EST 2015 x86_64
> Intel(R) Core(TM) i7-2600S CPU @ 2.80GHz GenuineIntel GNU/Linux
>
> # btrfs --version
> Btrfs v3.18.1
>
>
> --
> Sandy McArthur Jr
>
> "He who dares not offend cannot be honest."
> - Thomas Paine



-- 
Sandy McArthur

"He who dares not offend cannot be honest."
- Thomas Paine
