From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 13:02:19 +0100
Message-ID: <201112171302.20114.Martin@lichtvoll.de>
References: <201112171254.47334.Martin@lichtvoll.de> (sfid-20111217_125532_333048_50AE0C48)
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: Goffredo Baroncelli <kreijack@inwind.it>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112171254.47334.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 17. Dezember 2011 schrieb Martin Steigerwald:
> If BTRFS has other means to guarantee filesystem consistency that is
> faster  it might still make fsync() a no-op or just creating a
> snapshot temporarily automatically.

To clear this up: It should only make it a no-op if it guarentees the 
consistency without it. Otherwise it should do whatever is necessary to 
guarantee it.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
