Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:34236 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750765AbaGMRpr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Jul 2014 13:45:47 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs partition remounted read-only
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53C2C360.9080200@gmail.com>
Date: Sun, 13 Jul 2014 11:45:49 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <D731B02F-1F36-4D97-AF1C-319DD653E681@colorremedies.com>
References: <53B6DDAD.20504@gmail.com> <8C7CBE0A-D27D-4486-9A77-E7587418DF7A@colorremedies.com> <53C2C360.9080200@gmail.com>
To: Konstantin Svist <fry.kun@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 13, 2014, at 11:35 AM, Konstantin Svist <fry.kun@gmail.com> wrote:

> On 07/13/2014 10:13 AM, Chris Murphy wrote:
>> On Jul 4, 2014, at 11:00 AM, Konstantin Svist <fry.kun@gmail.com> wrote:
>> 
>>> I have an overnight cron job with
>>> 
>>> /sbin/fstrim -v /
>>> /bin/bedup dedup --defrag
>> Probably not related, but these look backwards, why not reverse them?
>> 
>> 
>> Chris Murphy
>> 
> 
> Thanks, will do that. Anything else useful I could add to the cron job,
> btw? I was thinking maybe a scrub operation to check for errors..

You might want separate jobs. fstrim should be done when the SSD isn't busy (or about to be), and you could do that maybe once a week. And scrub followed by deduplication maybe once a month. Separately schedule smartd to do extended offline test.


Chris Murphy

