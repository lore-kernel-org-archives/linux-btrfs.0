From: Diego Calleja <diegocg@gmail.com>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 5 Jan 2011 22:14:18 +0100
Message-ID: <201101052214.18240.diegocg@gmail.com>
References: <1294245410-4739-1-git-send-email-josef@redhat.com> <201101051941.13268.diegocg@gmail.com> <4D24D3C5.6080803@bobich.net>
Reply-To: diegocg@gmail.com
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D24D3C5.6080803@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mi=E9rcoles, 5 de Enero de 2011 21:25:41 Gordan Bobic escribi=F3:
> The point is that the offline dedup is actually twice as expensive, a=
nd=20
> the hashing part is nowhere nearly expensive as disk I/O. Disk I/O is=
=20
> very limited today, compared to CPU time.

And my point is:

> But there are people who might want to avoid temporally the extra cos=
t
> of online dedup, and do it offline when the server load is smaller.

In fact, there are cases where online dedup is clearly much worse. For
example, cases where people suffer duplication, but it takes a lot of
time (several months) to hit it. With online dedup, you need to enable
it all the time to get deduplication, and the useless resource waste
offsets the other advantages. With offline dedup, you only deduplicate
when the system really needs it.

And I can also imagine some unrealistic but theorically valid cases,
like for example an embedded device that for some weird reason needs
deduplication but doesn't want online dedup because it needs to save
as much power as possible. But it can run an offline dedup when the
batteries are charging.

It's clear to me that if you really want a perfect deduplication
solution you need both systems.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
