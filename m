From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [PATCH] btrfs-progs: mkfs: allow not to trim a device
Date: Mon, 19 Mar 2012 18:24:17 +0100
Message-ID: <201203191824.17665.Martin@lichtvoll.de>
References: <1332010297-18581-1-git-send-email-dsterba@suse.cz> (sfid-20120317_203421_882894_B477A55F)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332010297-18581-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

Am Samstag, 17. M=C3=A4rz 2012 schrieb David Sterba:
[=E2=80=A6]
> +	fprintf(stderr, "\t -T --nodiscard do not perform whole device
> TRIM\n"); fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);

Just curious: Whats the use case for this?

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
