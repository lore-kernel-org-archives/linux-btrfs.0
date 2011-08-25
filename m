From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: BTRFS and power loss ~= corruption?
Date: Thu, 25 Aug 2011 19:55:34 +0200
Message-ID: <201108251955.35283.Martin@lichtvoll.de>
References: <4E54F884.9090004@cyberwizzard.nl> <CAKcLGm8wYKKZ-yEX3_A612MJPLND3DnM-7+N_hw3LUxwQe837w@mail.gmail.com> <4E55C217.4080203@oracle.com> (sfid-20110825_102450_021619_3DA8F0D1)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	Berend Dekens <btrfs@cyberwizzard.nl>,
	Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E55C217.4080203@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 25. August 2011 schrieb Anand Jain:
>   anyways, solutions containing disk-write-cache disabled and SSD
>   is quite popular now a days. And in terms of random synchronous
>   write performance they are awesome.

There are SSD with capacitors such as Intel SSD 320. These according to=
=20
the vendor should write out all remaining writes that made it to the di=
sk=20
cache should a power loss occur.

I did not have any issues with BTRFS on / with a ThinkPad T520 and an=20
Intel SSD 320. /home is still Ext4, as I want a fsck first. Thats with=20
Linux 3.0.0-2 amd64 debian package.

That said I also do not have any issues with BTRFS on a ThinkPad T23 fo=
r /=20
and /home. But then the machine has an hibernate-to-disk-and-resume upt=
ime=20
of almost 120 days, so it didn=B4t see a power loss for a long time. Th=
ats=20
still with 2.6.38.4.

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
