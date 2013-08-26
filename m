Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43203 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751754Ab3HZP16 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 11:27:58 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: snapshot space available
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAFvQSYSgAPZkYUPF-pqSTGAQpHWAG7NDjBiJhwdxhsEqxSR+nA@mail.gmail.com>
Date: Mon, 26 Aug 2013 09:27:55 -0600
Cc: russell@coker.com.au, linux-btrfs@vger.kernel.org
Message-Id: <5FA1D778-230D-4EB5-B7C9-537ABFFC9EAA@colorremedies.com>
References: <201308262335.25871.russell@coker.com.au> <CAFvQSYSgAPZkYUPF-pqSTGAQpHWAG7NDjBiJhwdxhsEqxSR+nA@mail.gmail.com>
To: Clemens Eisserer <linuxhippy@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 26, 2013, at 8:47 AM, Clemens Eisserer <linuxhippy@gmail.com> wrote:

> You are out of metadata, not "normal space".
> However, the good question is why 0.5GB of metadata are unused and
> btrfs reports no space left.
> I have seen similar behaviour on a machine of mine, with exactly 0.5GB
> of metadata unused.

Since metadata is set to DUP, the numbers are actually 6GB allocated and 5GB used, and I'm guessing that at the time it starts to use the last chunk of allocated space, it also wants to allocate a new one. But it can't allocate more for metadata because all free space in the fs is already allocated for data chunks. 

Presently btrfs seems unable to unwind itself from this situation without a manual balance, which in many instances also requires more free space than is available once you're in this situation. So I called it a filesystem wedged into a corner. Fortunately so far I've found it to be rather docile in accepting a small device to give it a little extra free space, do a balance, and then delete the device from the volume.

I haven't tried doing a partial balance, deleting the extra device, then finishing the balance.

But this suggestion is certainly non-obvious to the mortal and sane. Especially if you do a df, which bases its values off the used portion of allocated chunks, the file system is distinctly not out of free space. So the confusion is understandable.


Chris Murphy