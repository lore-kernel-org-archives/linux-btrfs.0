Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-10v.sys.comcast.net ([69.252.207.42]:59179 "EHLO
	resqmta-ch2-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755813AbaJUPN3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 11:13:29 -0400
Message-ID: <54467817.5070307@pobox.com>
Date: Tue, 21 Oct 2014 08:13:27 -0700
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

Don't bother reformatting (yet). The on-disk layout is stable between 
the releases. It should run fine and all the known-to-date issues with 
3.17 only affected read-only snapshots, so your live data is still good.

I'd wait till things shake out before doing anything drastic to the 
working set.


