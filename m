Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52346 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaGMRfb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Jul 2014 13:35:31 -0400
Received: by mail-pa0-f49.google.com with SMTP id hz1so161270pad.36
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Jul 2014 10:35:31 -0700 (PDT)
Message-ID: <53C2C360.9080200@gmail.com>
Date: Sun, 13 Jul 2014 10:35:28 -0700
From: Konstantin Svist <fry.kun@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs partition remounted read-only
References: <53B6DDAD.20504@gmail.com> <8C7CBE0A-D27D-4486-9A77-E7587418DF7A@colorremedies.com>
In-Reply-To: <8C7CBE0A-D27D-4486-9A77-E7587418DF7A@colorremedies.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/13/2014 10:13 AM, Chris Murphy wrote:
> On Jul 4, 2014, at 11:00 AM, Konstantin Svist <fry.kun@gmail.com> wrote:
>
>> I have an overnight cron job with
>>
>> /sbin/fstrim -v /
>> /bin/bedup dedup --defrag
> Probably not related, but these look backwards, why not reverse them?
>
>
> Chris Murphy
>

Thanks, will do that. Anything else useful I could add to the cron job,
btw? I was thinking maybe a scrub operation to check for errors..


