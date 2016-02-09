Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36169 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbcBIOHF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 09:07:05 -0500
Received: by mail-wm0-f49.google.com with SMTP id p63so159675629wmp.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 06:07:05 -0800 (PST)
Subject: Re: BTRFS RAM requirements, RAID 6 stability/write holes and
 expansion questions
To: Mackenzie Meyer <snackmasterx@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAKr9ZMFwxZ01gw7SAyFReOfXFb=hVzUXNgYoGcUc2xzLuo+9mg@mail.gmail.com>
From: Psalle <psalleetsile@gmail.com>
Message-ID: <56B9F286.9070408@gmail.com>
Date: Tue, 9 Feb 2016 15:07:02 +0100
MIME-Version: 1.0
In-Reply-To: <CAKr9ZMFwxZ01gw7SAyFReOfXFb=hVzUXNgYoGcUc2xzLuo+9mg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/02/16 20:36, Mackenzie Meyer wrote:
> Hello,
>
> I've tried checking around on google but can't find information
> regarding the RAM requirements of BTRFS and most of the topics on
> stability seem quite old.

To keep my answer short: every time I've tried (offline) deduplication 
or raid5 pools I've ended with borked filesystems. Last attempt was 
about a year ago. Given that the pages you mention looked the same by 
then, I'd stay away of raid56 for anything but testing purposes. I 
haven't read anything about raid5 that increases my confidence in it 
recently (i.e. post 3.19 kernels). Dedup, OTOH, I don't know. What I 
used were third-party (I think?) things so the fault may have rested on 
them and not btrfs (does that makes sense?)

I'm building a new small raid5 pool as we speak, though, for throw-away 
data, so I hope to be favourably impressed.

Cheers.

> So first would be memory requirements, my goal is to use deduplication
> and compression. Approximately how many GB of RAM per TB of storage
> would be recommended?
>
> RAID 6 write holes?
> The BTRFS wiki states that parity might be inconsistent after a crash.
> That said, the wiki page for RAID 5/6 doesn't look like it has much
> recent information on there. Has this issue been addressed and if not,
> are there plans to address the RAID write hole issue? What would be a
> recommended workaround to resolve inconsistent parity, should an
> unexpected power down happen during write operations?
>
> RAID 6 stability?
> Any articles I've tried looking for online seem to be from early 2014,
> I can't find anything recent discussing the stability of RAID 5 or 6.
> Are there or have there recently been any data corruption bugs which
> impact RAID 6? Would you consider RAID 6 safe/stable enough for
> production use?
>
> Do you still strongly recommend backups, or has stability reached a
> point where backups aren't as critical? I'm thinking from a data
> consistency standpoint, not a hardware failure standpoint.
>
> I plan to start with a small array and add disks over time. That said,
> currently I have mostly 2TB disks and some 3TB disks. If I replace all
> 2TB disks with 3TB disks, would BTRFS then start utilizing the full
> 3TB capacity of each disk, or would I need to destroy and rebuild my
> array to benefit from the larger disks?
>
>
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

