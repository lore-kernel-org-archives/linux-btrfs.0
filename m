From: Oystein Viggen <oysteivi@tihlde.org>
Subject: Re: Configuring default mount options..
Date: Mon, 26 Jul 2010 08:08:54 +0200
Message-ID: <037hkiixl5.fsf@msgid.viggen.net>
References: <1280105806.3327.4.camel@hardline>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

* ["A. James Lewis"]=20

> Maybe there is a way to do this already, but it seems like the
> filesystem itself should contain preferences for the way it is used
> under those circumstances.

There has been talk of supporting per-file (and I assume recursive
per-directory default) attributes for raid level.  Things like
encryption and compression could fit well into such a scheme.

I don't believe the code for this is written yet, however.

=D8ystein
--=20
ssh -c rot13 otherhost

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
