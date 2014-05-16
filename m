Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:49226 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaEPSG1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 14:06:27 -0400
Received: by mail-ie0-f175.google.com with SMTP id y20so2849159ier.20
        for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 11:06:27 -0700 (PDT)
Message-ID: <1400263584.979.17.camel@sasami.ottawa.blindsidenetworks.com>
Subject: Re: RAID-1 - suboptimal write performance?
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Fri, 16 May 2014 14:06:24 -0400
In-Reply-To: <20140516164815.1c33149b@s9>
References: <20140516164815.1c33149b@s9>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-05-16 at 16:48 +0100, Tomasz Chmielewski wrote:
> While doing rsyncs of large archives from one RAID-1 btrfs filesystem
> to another RAID-1 btrfs filesystem:
> 
> btrfs filesystem 1: sda + sdb (RAID-1), being copied to:
> btrfs filesystem 2: sdc + sdd (RAID-1)
> Server has 32 GB RAM
> 
> 
> I can observe the following:
> 
> 
> From time to time, rsync "freezes", while there is high IO on only *one*
> of write drives.

No comment on the performance issue, other than to say that I've seen
similar on RAID-10 before, I think.

> Also, what happens when the system crashes, and one drive has several
> hundred megabytes data more than the other one?

This shouldn't be an issue as long as you occasionally run a scrub or
balance. The scrub should find it and fix the missing data, and a
balance would just rewrite it as proper RAID-1 as a matter of course.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

