From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Encryption implementation like ZFS?
Date: Sat, 31 Dec 2011 16:53:20 +0700
Message-ID: <CAG1y0sfD=AkD9VDf1=Njk9nyk_y+n3Pz9KEZSXevFzTUn7GwyA@mail.gmail.com>
References: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>
	<CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com>
	<CAELiMBP9g52fHQv=ur0Kjk+=kO9DWJMCh20RL+-2s_0pS7GVXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Billy Crook <billycrook@gmail.com>, linux-btrfs@vger.kernel.org
To: Sandra Schlichting <littlesandra88@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAELiMBP9g52fHQv=ur0Kjk+=kO9DWJMCh20RL+-2s_0pS7GVXg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 31, 2011 at 3:12 AM, Sandra Schlichting
<littlesandra88@gmail.com> wrote:
>> How is this advantageous over dmcrypt-LUKS?
>
> TRIM pass-through for SSD's. With dmcrypt on an SSD write performance
> is very slow.

... and depending on which SSD you use, it shouldn't matter. Really.

Last time I tried with sandforce SSD + btrfs + -o discard, forcing
trim actually made things slower. Sandforce (and probably other modern
SSD) controllers can work just fine even without explicit trim fs
support.

-- 
Fajar
