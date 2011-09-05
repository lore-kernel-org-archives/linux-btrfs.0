From: =?UTF-8?B?QmrDtnJuIEthbGticmVubmVy?= <terminar@cyberphoria.org>
Subject: Re: Problems with set-default, home subvolume and snapshot
Date: Mon, 05 Sep 2011 16:43:50 +0200
Message-ID: <4E64E026.4020009@cyberphoria.org>
References: <20110905130742.GA4756@zambezi.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110905130742.GA4756@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Ilya,

Am 05.09.2011 15:07, schrieb Ilya Dryomov:
> Well, it's *sort of* expected if you think about it. When you mounted
> after set-default, your /home is no longer a valid subvolume access
> point (it was in the default subvolume, until you rebooted). Inside
> your snapshot /home is just an empty directory (there's more to it,
> that's why you can't delete it, but that's irrelevant here). However
> if you mount with subvolid=3D<objectid>, you point to a subvolume
> directly, skipping the lookup (which leads to an empty dir if you are
> inside your snapshot). That's why it works when you use the subvolid.
> We should probably tune the lookup to make subvol=3D work in this cas=
e.=20

Ah, thank you very much, that sounds logical with the lookup table and
the - not valid access point - BUT:

Why could i still manually "mount -o subvol=3Dhome /dev/mapper/root /ho=
me"
and home was just empty but mounted (i looked at the mount table output=
)?
Shouldn't that give me an error that home can't be found in the lookup
table?

There was a difference between the content of subvol=3Dhome and
subvolid=3D256 and i was able to mount both but only one (id 256)
contained my data, the other seems to be empty.

> You say it's reproducable, can you give us a backtrace to look at ?=20

Yes, when the backup recovery job is done... And that's not really fast
currently due to external usb hd on my notebook... may take some time. =
;)


Bye
Bj=C3=B6rn
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
