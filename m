Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27406 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751297AbcESBda (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 21:33:30 -0400
Subject: Re: Reducing impact of periodic btrfs balance
To: Graham Cobb <g.btrfs@cobb.uk.net>, <linux-btrfs@vger.kernel.org>
References: <573C6E47.2080109@cobb.uk.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <d40d8fc7-3766-1ccc-3253-9f870a0f4f85@cn.fujitsu.com>
Date: Thu, 19 May 2016 09:33:19 +0800
MIME-Version: 1.0
In-Reply-To: <573C6E47.2080109@cobb.uk.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Graham Cobb wrote on 2016/05/18 14:29 +0100:
> Hi,
>
> I have a 6TB btrfs filesystem I created last year (about 60% used).  It
> is my main data disk for my home server so it gets a lot of usage
> (particularly mail). I do frequent snapshots (using btrbk) so I have a
> lot of snapshots (about 1500 now, although it was about double that
> until I cut back the retention times recently).

Even at 1500, it's still quite large, especially when they are all 
snapshots.

The biggest problem of large amount of snapshots is, it will make any 
backref walk operation very slow. (O(n^3)~O(n^4))
This includes: btrfs qgroup and balance, even fiemap (recently submitted 
patch will solve fiemap problem though)

The btrfs design ensures snapshot creation fast, but that comes with the 
cost of backref walk.


So, unless some super huge rework, I would prefer to keep the number of 
snapshots to a small amount, or avoid balance/qgroup.

>
> A while ago I had a "no space" problem (despite fi df, fi show and fi
> usage all agreeing I had over 1TB free).  But this email isn't about that.
>
> As part of fixing that problem, I tried to do a "balance -dusage=20" on
> the disk.  I was expecting it to have system impact, but it was a major
> disaster.  The balance didn't just run for a long time, it locked out
> all activity on the disk for hours.  A simple "touch" command to create
> one file took over an hour.

It seems that balance blocked a transaction for a long time, which makes 
your touch operation to wait for that transaction to end.

>
> More seriously, because of that, mail was being lost: all mail delivery
> timed out and the timeout error was interpreted as a fatal delivery
> error causing mail to be discarded, mailing lists to cancel
> subscriptions, etc. The balance never completed, of course.  I
> eventually got it cancelled.
>
> I have since managed to complete the "balance -dusage=20" by running it
> repeatedly with "limit=N" (for small N).  I wrote a script to automate
> that process, and rerun it every week.  If anyone is interested, the
> script is on GitHub: https://github.com/GrahamCobb/btrfs-balance-slowly
>
> Out of that experience, I have a couple of thoughts about how to
> possibly make balance more friendly.
>
> 1) It looks like the balance process seems to (effectively) lock all
> file (extent?) creation for long periods of time.  Would it be possible
> for balance to make more effort to yield locks to allow other
> processes/threads to get in to continue to create/write files while it
> is running?

Balance doesn't really lock the whole file system, and in fact itself 
will only lock(mark readonly) one block group (normally in 1G size).

But unfortunately, balance will hold one transaction for one block 
group, and that's the whole fs level, may blocks unrelated write operation.

>
> 2) btrfs scrub has options to set ionice options.  Could balance have
> something similar?  Or would reducing the IO priority make things worse
> because locks would be held for longer?

IMHO The problem is not about IO.
If using iotop, you would find that the IO active not that high, while 
CPU usage would be near 100% for one core.

>
> 3) My btrfs-balance-slowly script would work better if there was a
> time-based limit filter for balance, not just the current count-based
> filter.  I would like to be able to say, for example, run balance for no
> more than 10 minutes (completing the operation in progress, of course)
> then return.

As btrfs balance is done in block group unit, I'm afraid such thing 
would be a little tricky to implement.

>
> 4) My btrfs-balance-slowly script would be more reliable if there was a
> way to get an indication of whether there was more work to be done,
> instead of parsing the output for the number of relocations.
>
> Any thoughts about these?  Or other things I could be doing to reduce
> the impact on my services?

Would you try to remove unneeded snapshots and disable qgroup if you're 
using it?

If it's possible, it's better to remove *ALL* snapshots to minimize the 
backref walk pressure and then retry the balance.

Thanks,
Qu

>
> Graham
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


