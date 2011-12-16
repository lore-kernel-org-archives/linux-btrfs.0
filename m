From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: speeding up slow btrfs filesystem
Date: Fri, 16 Dec 2011 21:58:45 +0100
Message-ID: <201112162158.45819.Martin@lichtvoll.de>
References: <201112161851.52011.Martin@lichtvoll.de> <4906354.Rn8tlOeHyD@venice> <201112162053.58332.Martin@lichtvoll.de> (sfid-20111216_210600_117630_C2E8BC66)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112162053.58332.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 16. Dezember 2011 schrieb Martin Steigerwald:
> I wonder whether it might be a good idea to have nodatacow for /:

Nope. Doesn=B4t seem to help much.

How to turn it off, after turning it on?

deepdance:~> LANG=3DC mount -o remount,datacow /=20
mount: / not mounted already, or bad option

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
