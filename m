From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Confused by performance
Date: Wed, 16 Jun 2010 12:35:48 -0700
Message-ID: <AANLkTimKGCk7KlD4KQ8oXhnnOf0pj3VzzDmzzBIK0bNn@mail.gmail.com>
References: <4BFAEABD.2070700@noir.com>
	<4BFF2024.3040509@noir.com>
	<4C191330.5060905@noir.com>
	<4C19243E.9050507@robertoragusa.it>
	<AANLkTinM6ab_KEynfgvVT9v5TmcogoLZ0PLAz2oPnsiS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinM6ab_KEynfgvVT9v5TmcogoLZ0PLAz2oPnsiS@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

<snip a lot of fancy math that missed the point>

That's all well and good, but you missed the part where he said ext2
on a 5-way LVM stripeset is many times faster than btrfs on a 5-way
btrfs stripeset.

IOW, same 5-way stripeset, different filesystems and volume managers,
and very different performance.

And he's wondering why the btrfs method used for striping is so much
slower than the lvm method used for striping.

--
Freddie Cash
fjwcash@gmail.com



--
Freddie Cash
fjwcash@gmail.com
