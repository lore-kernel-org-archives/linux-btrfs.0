Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:53652 "EHLO
	resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbaJUPUc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 11:20:32 -0400
Message-ID: <544679BE.9080901@pobox.com>
Date: Tue, 21 Oct 2014 08:20:30 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Cristian Falcas <cristi.falcas@gmail.com>, Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: downgrade from kernel 3.17 to 3.10
References: <CAMo7R_e9=wdGhEm9P+DZgXrKQ+qrKqdELzwwi-OMTCp6Mk8aTg@mail.gmail.com> <pan$e55c6$e7985780$d6580cb2$76eb6d4@cox.net> <CAMo7R_egQMGXs4nJBPkp86QkF9owpUhAh6P_Vn65wN84J7B95w@mail.gmail.com>
In-Reply-To: <CAMo7R_egQMGXs4nJBPkp86QkF9owpUhAh6P_Vn65wN84J7B95w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/21/2014 06:18 AM, Cristian Falcas wrote:
> Thank you for your answer.
>
> I will reformat the disk with a 3.10 kernel in the meantime, because I
> don't have any rpms for 3.16 now.

More concisely: Don't use 3.10 BTRFS for data you value. There is a 
non-trivial chance that the problems you observed are/were due to "bad 
things" on the disk written there by 3.10.

There is no value to recreating your file systems under 3.10 as the same 
thing is likely to go bad again when you get out of the dungeon.

What are your RPM options? What about just getting the sources from 
kernel.org and compiling your won 3.16.5?

Seriously, 3.10.... just... no...

8-)

