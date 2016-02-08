Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:41393 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbcBHMPl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Feb 2016 07:15:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 08 Feb 2016 21:15:38 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 4.4.0 - no space left with >1.7 TB free space left
In-Reply-To: <20160208162410.58cb2b4a@natsu>
References: <0c19f800da3013f22f2ab0d77d5a9efb@admin.virtall.com>
 <20160208162410.58cb2b4a@natsu>
Message-ID: <5752ed994dd80b90cf91f7006f037a05@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-08 20:24, Roman Mamedov wrote:
> On Mon, 08 Feb 2016 18:22:34 +0900
> Tomasz Chmielewski <tch@virtall.com> wrote:
> 
>> Linux 4.4.0 - btrfs is mainly used to host lots of test containers,
>> often snapshots, and at times, there is heavy IO in many of them for
>> extended periods of time. btrfs is on HDDs.
>> 
>> 
>> Every few days I'm getting "no space left" in a container running 
>> mongo
>> 3.2.1 database. Interestingly, haven't seen this issue in containers
>> with MySQL. All databases have chattr +C set on their directories.
> 
> Hello,
> 
> Do you snapshot the parent subvolume which holds the databases? Can you
> correlate that perhaps ENOSPC occurs at the time of snapshotting?

Not sure.

With the last error, a snapshot was made at around 06:06, while "no 
space left" was reported on 06:14. Suspiciously close to each other, but 
still, a few minutes away.

Unfortunately I don't have error log for previous cases.


> If yes, then
> you should try the patch https://patchwork.kernel.org/patch/7967161/
> 
> (Too bad this was not included into 4.4.1.)

I'll keep an eye on it, thanks.


Tomasz Chmielewski
http://www.ptraveler.com

