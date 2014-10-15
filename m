Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:59327 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbaJOTHI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 15:07:08 -0400
Message-ID: <543EC5DA.9040905@pobox.com>
Date: Wed, 15 Oct 2014 12:07:06 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Wishlist Item :: One Subvol in Multiple Places
References: <543DA2E3.3070503@pobox.com> <543E5AD2.6080207@gmail.com>
In-Reply-To: <543E5AD2.6080207@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/15/2014 04:30 AM, Austin S Hemmelgarn wrote:
> On 2014-10-14 18:25, Robert White wrote:
>> I've got no idea if this is possible given the current storage layout,
>> but it would be Really Nice™ if there were a way to have a single
>> subvolume exist in more than one place in hirearchy. I know this can be
>> faked via mount tricks (bind or use of subvol=), but having it be a real
>> thing would be preferable.
>>
>> For example, if I have two or more distributions on a computer or want
>> to switch between 32bit and 64bit environments frequently, but I want to
>> use the same /home (which is its own subvolume anyway) it would be nice
>> if the native layout could be permuted such that /__System_32/home and
>> /__System_64/home were the actual same subvolume.
>>
>> The mechanism, were it possible, would be something like "btrfs
>> subvolume link /existing/path /new/path" (or "bind" instead of "link")
>>
>> I've got no idea if the directory structure would allow for this, but if
>> it would it would simplify several things (for me anyway) if the file
>> system layout represented the runtime layout.
> This probably won't be implemented, for the same reason that most modern
> unix systems disallow hardlinks to directories; namely, it results in
> ambiguity regarding resolution of the .. directory entry.
> The better solution would be to put /home in a separate top-level
> sub-volume, and then mount that in each location.

Oh. Duh. I knew that...

Some days the brain, you know... 8-)

--Rob.

