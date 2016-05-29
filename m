Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp41.i.mail.ru ([94.100.177.101]:56266 "EHLO smtp41.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213AbcE2ORR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 10:17:17 -0400
Received: from 77-173-215-182.ip.telfort.nl ([77.173.215.182]:37006 helo=centurion)
	by smtp41.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1b71Wk-0003fX-6H
	for linux-btrfs@vger.kernel.org; Sun, 29 May 2016 17:17:14 +0300
Received: from [192.168.1.85] (Furia.home [192.168.1.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by centurion (Postfix) with ESMTPSA id 98617128F8C
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 16:17:11 +0200 (CEST)
Subject: Re: Some ideas for improvements
To: linux-btrfs@vger.kernel.org
References: <45a47ee4db4cc92248f91f1d00e8ed03@www.centurion.link>
 <pan$4409c$50898a15$4d9b8e7d$2537805b@cox.net>
From: Dmitry Katsubo <dma_k@mail.ru>
Message-ID: <574AF9E7.8080502@mail.ru>
Date: Sun, 29 May 2016 16:17:11 +0200
MIME-Version: 1.0
In-Reply-To: <pan$4409c$50898a15$4d9b8e7d$2537805b@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-25 21:03, Duncan wrote:
> Dmitry Katsubo posted on Wed, 25 May 2016 16:45:41 +0200 as excerpted:
>> * Would be nice if 'btrfs scrub status' shows estimated finishing time
>> (ETA) and throughput (in Mb/s).
> 
> That might not be so easy to implement.  (Caveat, I'm not a dev, just a 
> btrfs user and list regular, so if a dev says different...)
> 
> Currently, a running scrub simply outputs progress to a file (/var/lib/
> btrfs/scrub.status.<UUID>), and scrub status is simply a UI to pretty-
> print that file.  Note that there's nothing in there which lists the 
> total number of extents or bytes to go -- that's not calculated ahead of 
> time.
> 
> So implementing some form of percentage done or eta is likely to increase 
> the processing time dramatically, as it could involve doing a dry-run 
> first, in ordered to get the total figures against which to calculate 
> percentage done.

Indeed that this cannot (should not) be done on user-space level: kernel
module should provide information about that. I am not a dev :) but I
think module should now number of extents, at least something is shown in
"btrfs fi usage ..." output.

The information shouldn't be 100% exact, but at least some indication
would be great. In worst scenario module can remember the last scrub
time and make estimation based on that (similar how some CD burning
utilities do).

>> * Not possible to start scrub for all devices in the volume without
>> mounting it.
> 
> Interesting.  It's news to me that you can scrub individual devices 
> without mounting.  But given that, this would indeed be a useful feature, 
> and given that btrfs filesystem show can get the information, scrub 
> should be able to get and make use of it as well. =:^)

More over I got into a trap when tried to use "btrfs scrub start /dev/..."
syntax, as I only scrubs the given device. When I scrubbed the whole
volume after mounting it, de result was different. I understood it only
after reading man btrfs-scrub more attentively:

  start ... <path>|<device>

  Start a scrub on all devices of the filesystem identified by <path>
  or on a single <device>.

Other (shorter) forms of help misled me, giving the impression that
it does not matter whether I specify a path or device.

On 2016-05-26 00:05, Duncan wrote:
> Nicholas D Steeves posted on Wed, 25 May 2016 16:36:13 -0400 as excerpted:
>> On 25 May 2016 at 15:03, Duncan <1i5t5.duncan@cox.net> wrote:
>>> Dmitry Katsubo posted on Wed, 25 May 2016 16:45:41 +0200 as excerpted:
>>>> btrfs-restore [needs an o]ption that applies (y) to all questions
>>>> (completely unattended recovery)
>>>
>>> That['s] a known sore spot that a lot of people have complained
>>> about.
> 
>> I'm surprised no one has mentioned, in any of these discussions, what I
>> believe is the standard method of providing this functionality:
>> yes | btrfs-restore -options /dev/disk
> 
> Good point.
> 
> I didn't bring it up because while I've used btrfs restore a few times, 
> my btrfs are all on relatively small SSD partitions, so I both needed 
> less y's, and the total time per restore is a few minutes, not hours, so 
> it wasn't a big deal.  As a result, while I know of yes, I didn't need to 
> think about automation, and as I never used it, it didn't occur to me to 
> suggest it for others.

Thanks for advise, Nicholas. Last time I tried it I used the following
command:

while true; do echo y; done | btrfs restore -voxmSi /dev/sda /mnt/tmp &> btrfs_restore &

which presumably is equivalent to what you suggest. The command was in
"running" state in "jobs" output for a while, but then turned into
"waiting" state and did not progress. I suspect that btrfs-restore
somehow reads directly from terminal, not from stdin. I will try the
solution with "yes | btrfs-restore..." once I get a chance.

-- 
With best regards,
Dmitry
