Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35871 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932259AbcHISC4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Aug 2016 14:02:56 -0400
Subject: Re: btrfs dev del hangs on 4.7
To: Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
References: <20160809172758.GB9644@carfax.org.uk>
From: Chris Mason <clm@fb.com>
Message-ID: <23be7ecd-500b-76ed-ea91-88885872031e@fb.com>
Date: Tue, 9 Aug 2016 14:02:20 -0400
MIME-Version: 1.0
In-Reply-To: <20160809172758.GB9644@carfax.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/09/2016 01:27 PM, Hugo Mills wrote:
>    Over the weekend, I started doing some maintenance on my server: I
> upgraded to 4.7.0, and I started deleting a device from my array,
> preparatory to putting in a larger one. About halfway through the
> operation, several kernel threads hung up for a while (resulting in
> "blocked for 120s" messages), and then the delete process seems to
> have stopped entirely, although several kernel threads are at maximum
> usage.
>
>    After a few hours, I rebooted the machine, and left it for a day or
> so. I tried the delete again this afternoon, and it's done the same
> thing again. The full log is included below. I have a kworker and a
> btrfs-transaction pegged at close to 100% of a core each, and a
> btrfs-cleaner (and the btrfs dev del process) in D state.
>
>    The FS was not under load at the time of the failure, and it passes
> scrub. I haven't tried a btrfs check yet.

Thanks Hugo, can you nail down which line of code belongs to:

btrfs_async_run_delayed_refs+0xc6

-chris
