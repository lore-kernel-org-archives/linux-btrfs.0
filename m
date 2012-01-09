From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: How long does it take to balance a 2x1TB RAID1 ?
Date: Mon, 09 Jan 2012 10:01:10 -0500
Message-ID: <4F0B0136.7060205@cfl.rr.com>
References: <je6lin$m0e$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-btrfs@vger.kernel.org
To: =?UTF-8?B?RGlyayBMdXR6ZWLDpGNr?= <dirk@lutzebaeck.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <je6lin$m0e$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 1/6/2012 6:23 AM, Dirk Lutzeb=C3=A4ck wrote:
> Hi,
>
> I have setup up a btrfs RAID1 using two 1TB drives. How long should a
> 'btrfs filesystem balance' take? It is running now for more than 3 da=
ys
> on about 30% CPU and 40% wait state.
>
> I am using stock btrfs from ubuntu 11.10 kernel 3.0.0

Not nearly that long.  Assuming it actually has to rewrite 1 TB of data=
=20
and is only getting 50 MB/s, that should only take about 5.5 hours.  Yo=
u=20
might want to try a newer kernel ( like the one from 12.04 ).
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
