From: Xavier Nicollet <nicollet@jeru.org>
Subject: Re: Checksum and transform layering
Date: Thu, 6 Nov 2008 16:27:29 +0100
Message-ID: <20081106152729.GN29514@jeru.org>
References: <e692861c0811052234h704c938es20b562123aa4fe9b@mail.gmail.com> <1225982445.15281.15.camel@think.oraclecorp.com> <e692861c0811060658n27427188k4cb6c63443bf2221@mail.gmail.com>
Reply-To: nicollet@jeru.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <e692861c0811060658n27427188k4cb6c63443bf2221@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Le 06 novembre 2008 =E0 09:58, Gregory Maxwell a =E9crit:
> The latter would need to be a probably need to be a secret-keyed HMAC
> to prevent watermarking attacks and information leakage, [...]

Dm-crypt on every disks seems a good alternative, doesn't it ?
You would use dm-crypt for your swap anyway.

Did I miss something ?

--=20
Xavier Nicollet
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
