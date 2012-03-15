From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Subject: Re: [weird] High CPU usage caused by btrfs-transaction thread busy
 doing find_next_zero_bit()
Date: Wed, 14 Mar 2012 23:16:16 -0400
Message-ID: <20120314231616.601de469@Bidule>
References: <20120222112021.2c8c4d4b@Malcolm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120222112021.2c8c4d4b@Malcolm>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 22 Feb 2012 11:20:21 -0500
J=C3=A9r=C3=B4me Carretero <cJ-ko@zougloub.eu> wrote:

> My filesystem is super-sluggish since about a week, and perf top tell=
s me
> that find_next_bit(), find_next_zero_bit() is eating my netbook's CPU=
=2E
>=20
> The kernel is 3.3-rc3+188 (g3ec1e88) and I don't use this laptop a lo=
t,
> so I'm ready to cooperate.

This machine was updated to today's kernel, and behaves same as before.
scrub says nothing, but btrfsck doesn't like to be run.

Does this interest someone (metadump image) or I can reformat the drive=
 ?

Regards,

--=20
cJ
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
