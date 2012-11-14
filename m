Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:56385 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab2KNQRp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 11:17:45 -0500
Message-ID: <50A3C425.4050401@brockmann-consult.de>
Date: Wed, 14 Nov 2012 17:17:41 +0100
From: Peter Maloney <peter.maloney@brockmann-consult.de>
MIME-Version: 1.0
To: =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>
CC: Alex <alex@bpmit.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, getting darn slower everyday
References: <50714AC8.4010100@petaramesh.org> <loom.20121007T141248-114@post.gmane.org> <50718151.8090506@petaramesh.org>
In-Reply-To: <50718151.8090506@petaramesh.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-07 15:19, Swâmi Petaramesh wrote:
> Hi again ;-)
> Le 07/10/2012 14:33, Alex a écrit :
>> 1. Convert to a 16k or 32k leafsize.
> How should I do this ? Can I do this on a live FS, and isn't this going
> to double my on-disk used space (I have active snapshots...)
>> 2. defragment (each non-trivial file) every now and again
> I believed that the "autodefrag" mount option was supposed to avoid the
> need for manual defrags...?
>
> Plus, with respect to snapshots, isn't this going to increase a lot my
> used disk space ?
>
>> 3. Note that btrfs in kernel 3.6 (vs 3.5) does appear to be quite a bit quicker.
> I'm not sure that "a bit" quicker will be enough, when I see my BTRFS is
> currently about 8x slower than what ext4 user to...
>
Here is a graph to reinforce what Alex said about performance after
3.5.x. This graph was posted in #btrfs on freenode. At the end of the
graph, the poster said that he upgraded from a 3.5.x to a 3.6.x

https://pipebreaker.pl/dump/loadl.png

I noticed the same thing going from 3.5.0 to 3.7.0rc2; system usage is
much lower. Before this I would often find huge lags and then check and
see btrfs-cleaner, btrfs-transactionhelpersomething, etc. taking up 100%
io. So if your system usage is high, this will help.


Also possibly not relevant for you: on my desktop, (btrfs or ext4, with
consumer disks) I find that deadline scheduler and nr_requests of 8 is
vastly superior for reducing GUI lags. (default is scheduler cfq and 128
nr_requests). But for servers, I don't know what to recommend.

