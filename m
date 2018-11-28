Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11D3C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 16:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F50D2081B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 16:05:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ETXLNj6l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F50D2081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gelma.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbeK2DHq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 22:07:46 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38575 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728624AbeK2DHp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 22:07:45 -0500
Received: by mail-pf1-f195.google.com with SMTP id q1so10382139pfi.5
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 08:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iaOa1mYHUoYPij2wazKKLkPy8HIRG0hx2gLVSMRENnM=;
        b=ETXLNj6lLpC29eKZ/faK42Joa14WWm+blzMcantlMB3Hrs19U3dXELV4Rx0eB3kFxh
         LIYSicp0VeNI8y/LOH/KNcGz9lVIVGqGGGGFVkLVsQh+BSaIoaEZxUkDFTvN7w1w30VT
         Hq2sOY+chw/n+9dq9yN4ZCh8JnuaBqxQfkoTefN01bdwufIJeumqYPFPfoRq55xAMUkJ
         6KS3Ud6ALjr+/izBYzy/D2TVJet9XTq0b0KJPu8vNj01vT/Hv8vBotKxraLLjvTcdbdo
         Rcs1XsCYlqvAqylZLxhq15Iq7KMH+y4M5FC9MfnwtZQGShJxuSBqYmuE5HlE2TLqyoA9
         gkhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=iaOa1mYHUoYPij2wazKKLkPy8HIRG0hx2gLVSMRENnM=;
        b=RPPYcFbfNSWeJz6R36yE1Cl7nuAfMUk47EogfP2muTU80p31J9283ZXHKsewDFC9FE
         pMCcB5O/OIu8TNra9+Ewh3K3gMd9gwewnax68BSERJscbt2PFek3lQXi4yEAlkLq43oO
         FOi6JueIAnNk7iw8d1frikZLRyngtAcIru5lNGYB3PiJFcXCWy4MJ1AYZAUuejHFzFDY
         IgMg0ATklXx3BDyxIDAzqVb4rmENNvKJq5CHrIxXyKN06xvzNy5aDOYfIMJYHmK6T755
         rVrizs6Eh4GcbQslsZpzq3M6PW4lkK6TA5XDNIYnQiSDcLhCGnorf0xrliULxW2hRmjL
         n57A==
X-Gm-Message-State: AA+aEWZYFLz4y1YR2w7Cfffs06E2JaHByqe77hbm1ubG59JkyvUro8kT
        zzjXBEooTZYM4/nwAmkQTQ0=
X-Google-Smtp-Source: AFSGD/WbELtEIthZcQF57W4oZVYO3QT4RbYRbV3XpGvvVqD7CWYFHArB9xO+TR/Zq+xSffZoxV+WHw==
X-Received: by 2002:a62:2a4b:: with SMTP id q72mr22064954pfq.61.1543421135855;
        Wed, 28 Nov 2018 08:05:35 -0800 (PST)
Received: from glet (anon-35-50.vpn.ipredator.se. [46.246.35.50])
        by smtp.gmail.com with ESMTPSA id k63sm17309777pfc.76.2018.11.28.08.05.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Nov 2018 08:05:34 -0800 (PST)
Date:   Wed, 28 Nov 2018 17:05:23 +0100
From:   Andrea Gelmini <andrea.gelmini@gelma.net>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Linux-next regression?
Message-ID: <20181128160523.GA5288@glet>
References: <20181126150137.GA16029@glet>
 <845890af-0659-fbfa-c445-d6f109bd5015@gmx.com>
 <20181127141144.GA23269@glet>
 <4f1bb6e7-434a-47d2-a75f-8aca702f5395@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <4f1bb6e7-434a-47d2-a75f-8aca702f5395@gmx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 27, 2018 at 10:16:52PM +0800, Qu Wenruo wrote:
>
> But it's less a concerning problem since it doesn't reach latest RC, so
> if you could reproduce it stably, I'd recommend to do a bisect.

No problem to bisect, usually.
But right now it's not possible for me, I explain further.
Anyway, here the rest of the story.

So, in the end I:
a) booted with 4.20.0-rc4
b) updated backup
c) did the btrfs check --read-only
d) seven steps, everything is perfect
e) no complains on screen or in logs (never had)
f) so, started to compile linux-next 20181128 (on another partition)
e) without using (reading or writing) on /home, I started
f) btrfs filesystem defrag -v -r -t 128M /home
g) it worked without complain (in screen or logs)
h) then, reboot with kernel tag 20181128
i) and no way to mount:

------
nov 28 15:44:03 glet kernel: BTRFS: device label home devid 1 transid 37360 /dev/mapper/cry-home
nov 28 15:44:04 glet kernel: BTRFS info (device dm-3): use lzo compression, level 0
nov 28 15:44:04 glet kernel: BTRFS info (device dm-3): turning on discard
nov 28 15:44:04 glet kernel: BTRFS info (device dm-3): enabling auto defrag
nov 28 15:44:04 glet kernel: BTRFS info (device dm-3): disk space caching is enabled
nov 28 15:44:04 glet kernel: BTRFS info (device dm-3): has skinny extents
nov 28 15:44:04 glet kernel: BTRFS error (device dm-3): bad tree block start, want 2150302023680 have 17816181330383341936
nov 28 15:44:04 glet kernel: BTRFS error (device dm-3): failed to read block groups: -5
nov 28 15:44:04 glet kernel: BTRFS error (device dm-3): open_ctree failed
------

l) get back to 4.20.0-rc4
m) mounted, but after a few minutes, I get this:

------
nov 28 15:51:23 glet kernel: BTRFS warning (device dm-3): block group 2199347265536 has wrong amount of free space
nov 28 15:51:23 glet kernel: BTRFS warning (device dm-3): failed to load free space cache for block group 2199347265536, rebuilding it now
nov 28 15:51:23 glet kernel: BTRFS warning (device dm-3): block group 2196126040064 has wrong amount of free space
nov 28 15:51:23 glet kernel: BTRFS warning (device dm-3): failed to load free space cache for block group 2196126040064, rebuilding it now
nov 28 15:52:09 glet kernel: BTRFS warning (device dm-3): block group 2184314880000 has wrong amount of free space
nov 28 15:52:09 glet kernel: BTRFS warning (device dm-3): failed to load free space cache for block group 2184314880000, rebuilding it now
nov 28 15:52:09 glet kernel: BTRFS warning (device dm-3): block group 2183241138176 has wrong amount of free space
nov 28 15:52:09 glet kernel: BTRFS warning (device dm-3): failed to load free space cache for block group 2183241138176, rebuilding it now
nov 28 15:52:53 glet kernel: BTRFS warning (device dm-3): block group 2152102625280 has wrong amount of free space
nov 28 15:52:53 glet kernel: BTRFS warning (device dm-3): failed to load free space cache for block group 2152102625280, rebuilding it now
nov 28 15:54:13 glet kernel: BTRFS warning (device dm-3): block group 2530059747328 has wrong amount of free space
nov 28 15:54:13 glet kernel: BTRFS warning (device dm-3): failed to load free space cache for block group 2530059747328, rebuilding it now
nov 28 15:55:10 glet kernel: BTRFS warning (device dm-3): block group 2151028883456 has wrong amount of free space
nov 28 15:55:10 glet kernel: BTRFS warning (device dm-3): failed to load free space cache for block group 2151028883456, rebuilding it now
nov 28 15:55:48 glet kernel: BTRFS warning (device dm-3): block group 2203642232832 has wrong amount of free space
nov 28 15:55:48 glet kernel: BTRFS warning (device dm-3): failed to load free space cache for block group 2203642232832, rebuilding it now
------

n) and then read-only mode:

------
[ 1058.996960] BTRFS error (device dm-3): bad tree block start, want 2150382092288 have 159161645701828393
[ 1058.996967] BTRFS: error (device dm-3) in __btrfs_free_extent:6831: errno=-5 IO failure
[ 1058.996969] BTRFS info (device dm-3): forced readonly
[ 1058.996971] BTRFS: error (device dm-3) in btrfs_run_delayed_refs:2978: errno=-5 IO failure
[ 1059.002857] BTRFS error (device dm-3): pending csums is 97832960
------

So, ok, for the moment I'm very sorry I can't help you with bisect, because I have to
revert to ext4. This is the laptop I use to work with.

If I can help you investigating, just tell me.

Thanks for your time,
Gelma

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQKTBAABCgB9FiEE6kLpNgt13W6DJUf3pDCQdfBZYPYFAlv+vLtfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldEVB
NDJFOTM2MEI3NURENkU4MzI1NDdGN0E0MzA5MDc1RjA1OTYwRjYACgkQpDCQdfBZ
YPYi+Q//UClKRCp5tgBMko1Vq3Id5ZGIh6zSctAWuClSIcMLL93NcuOrWHi6BNYX
piwRnSKGHTUFA+9/+1ARUeiiRd2N8aC9o69wcv1FqAVzQZih2xwhJzOmT5BLBmiE
JH+rEq1ql6i9iyLdyg8K3oRnvxyqw81iwH9C2Je7YDJNpSBRYlw2AANRmjCXK3l4
yPL9LB3uv0nQu6fCLfLLnZW5tj7COEeEFdDpf5/pOH0ShOa8t+iNfOvvONCSS0/D
2E2Gxz7pP4sFOszOc4TEjyn00056ze4sOdLdGHjOYuiG+RnB6VjasP7DUFnYUgHh
K/VVQSJ/MLS2rFkRuacvgV0JgyGTAI6HUdOMjGO0qjmQvVhN6++Q0mE2GOHJx72G
W/jibb2SDp40pX3jvRQoc2KqMzfg9Cy4E+6QcrxiKS3Y1S2Sd+UO7i8A/9TAORb8
1qKFILTZKmUJ5LiNZZSHF1giiQHkidTencCNTTjV3fEwuBlT8j4z5btdpskjJWgi
8H5uCt4oCXcquW3T6b77h/ikM9TnSta2FuLnEvPj8j1x++qnNkFKo7vE2uxkyQNg
LYyRvmpT5wK5a966Kv+V+dusGYE7fwdygHZSZBhu0EaJL6gFLITph4hy3Ixp3PB9
tiymIzNYzhYgMisl9jlXJQ9xWxiQh4/mq8M5z26nNCSMncXECLI=
=bruf
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
