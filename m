Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:37051 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759462AbcCECqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Mar 2016 21:46:35 -0500
Received: by mail-ig0-f182.google.com with SMTP id z8so7852243ige.0
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Mar 2016 18:46:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ88j0axsFA3HFc6Cr5o-dtYxLau_iDS2Mx2uVzKvF5HCe9F5Q@mail.gmail.com>
References: <c2e396477401f3441bdc364456b399f4@smoula.net>
	<CAJCQCtRP6yNOk-oDy9dOiuTL1e19SB9H9cjueEZVsCwJS4vC6w@mail.gmail.com>
	<CAJ88j0axsFA3HFc6Cr5o-dtYxLau_iDS2Mx2uVzKvF5HCe9F5Q@mail.gmail.com>
Date: Fri, 4 Mar 2016 19:46:34 -0700
Message-ID: <CAJCQCtS6cMjc0MQZresKJpkDnhLF7st2wyvwCKmsPSaT3mYmbw@mail.gmail.com>
Subject: Re: ENOSPC while creating snapshot
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?B?TWFydGluIE1seW7DocWZ?= <nexus@smoula.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 4, 2016 at 4:16 PM, Martin Mlynář <nexus@smoula.net> wrote:

(rw,noatime,nodatasum,nodatacow,ssd,discard,space_cache,enospc_debug,commit=900,subvolid=5,subvol=/)
>>
>> Most likely unrelated but commit time of 15 minutes? Umm, OK why?
>
>
> I'm trying to reduce writes to my ssd.

This will not reduce writes. It will only delay them. And it increases
the chance of data loss by a lot.


-- 
Chris Murphy
