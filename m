From: Diego Calleja <diegocg@gmail.com>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 5 Jan 2011 19:41:13 +0100
Message-ID: <201101051941.13268.diegocg@gmail.com>
References: <1294245410-4739-1-git-send-email-josef@redhat.com> <4D24AD92.4070107@bobich.net>
Reply-To: diegocg@gmail.com
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D24AD92.4070107@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mi=E9rcoles, 5 de Enero de 2011 18:42:42 Gordan Bobic escribi=F3:
> So by doing the hash indexing offline, the total amount of disk I/O=20
> required effectively doubles, and the amount of CPU spent on doing th=
e=20
> hashing is in no way reduced.

But there are people who might want to avoid temporally the extra cost
of online dedup, and do it offline when the server load is smaller.

In my opinion, both online and offline dedup have valid use cases, and
the best choice is probably implement both.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
