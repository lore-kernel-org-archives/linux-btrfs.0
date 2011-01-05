From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 05 Jan 2011 20:25:41 +0000
Message-ID: <4D24D3C5.6080803@bobich.net>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>	<4D24AD92.4070107@bobich.net> <201101051941.13268.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101051941.13268.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/05/2011 06:41 PM, Diego Calleja wrote:
> On Mi=E9rcoles, 5 de Enero de 2011 18:42:42 Gordan Bobic escribi=F3:
>> So by doing the hash indexing offline, the total amount of disk I/O
>> required effectively doubles, and the amount of CPU spent on doing t=
he
>> hashing is in no way reduced.
>
> But there are people who might want to avoid temporally the extra cos=
t
> of online dedup, and do it offline when the server load is smaller.

The point is that the offline dedup is actually twice as expensive, and=
=20
the hashing part is nowhere nearly expensive as disk I/O. Disk I/O is=20
very limited today, compared to CPU time.

Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
