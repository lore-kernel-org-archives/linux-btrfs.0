From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 05 Jan 2011 21:21:55 +0000
Message-ID: <4D24E0F3.9040902@bobich.net>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>	<201101051941.13268.diegocg@gmail.com> <4D24D3C5.6080803@bobich.net> <201101052214.18240.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101052214.18240.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/05/2011 09:14 PM, Diego Calleja wrote:
> In fact, there are cases where online dedup is clearly much worse. For
> example, cases where people suffer duplication, but it takes a lot of
> time (several months) to hit it. With online dedup, you need to enable
> it all the time to get deduplication, and the useless resource waste
> offsets the other advantages. With offline dedup, you only deduplicate
> when the system really needs it.

My point is that on a file server you don't need to worry about the CPU 
cost of deduplication because you'll run out of I/O long before you run 
out of CPU.

> And I can also imagine some unrealistic but theorically valid cases,
> like for example an embedded device that for some weird reason needs
> deduplication but doesn't want online dedup because it needs to save
> as much power as possible. But it can run an offline dedup when the
> batteries are charging.

That's _very_ theoretical.

> It's clear to me that if you really want a perfect deduplication
> solution you need both systems.

I'm not against having both. :)

Gordan
