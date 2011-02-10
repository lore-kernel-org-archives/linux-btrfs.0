From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: [PATCH] Btrfs-progs use safe string manipulation functions
Date: Thu, 10 Feb 2011 12:21:50 +0100
Message-ID: <AANLkTi=OaU8Wj+W2KuPZLbq_85_yVK9mTer9Q7hfTCUc@mail.gmail.com>
References: <1297081322.4615.10.camel@monotop>
	<4D53C711.3000309@nsc.liu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Eduardo Silva <eduardo.silva@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Thomas Bellman <bellman@nsc.liu.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D53C711.3000309@nsc.liu.se>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 10, 2011 at 12:08 PM, Thomas Bellman <bellman@nsc.liu.se> w=
rote:
> =C2=A0 =C2=A0strncpy(args.name, source, BTRFS_PATH_NAME_MAX);
> =C2=A0 =C2=A0args.name[BTRFS_PATH_NAME_MAX] =3D '\0';

That's silly. Isn't there a sane safe variant of strcpy?

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
