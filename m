From: Sandra Schlichting <littlesandra88@gmail.com>
Subject: Re: Encryption implementation like ZFS?
Date: Fri, 30 Dec 2011 21:12:05 +0100
Message-ID: <CAELiMBP9g52fHQv=ur0Kjk+=kO9DWJMCh20RL+-2s_0pS7GVXg@mail.gmail.com>
References: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>
	<CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Billy Crook <billycrook@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> How is this advantageous over dmcrypt-LUKS?

TRIM pass-through for SSD's. With dmcrypt on an SSD write performance
is very slow.

> LUKS has always been supported between the block device and a btrfs
> filesystem, and would not even let an attacker discern what type of
> file-system was in use.

cryptsetup-1.4.0-1 have --enable-discards option to allow
discards/TRIM, but it is not recommended for theoretical security
reasons.

>From my understanding some btrfs features wouldn't work with dmcrypt,
like "online volume growth and shrinking"?
