From: Billy Crook <billycrook@gmail.com>
Subject: Re: Encryption implementation like ZFS?
Date: Fri, 30 Dec 2011 14:49:06 -0600
Message-ID: <CANZ96zXurbiy=WOOmULcs13fiQomuw=WzDtqm-KFptCx_4TA5A@mail.gmail.com>
References: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>
 <CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com> <CAELiMBP9g52fHQv=ur0Kjk+=kO9DWJMCh20RL+-2s_0pS7GVXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Sandra Schlichting <littlesandra88@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAELiMBP9g52fHQv=ur0Kjk+=kO9DWJMCh20RL+-2s_0pS7GVXg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 30, 2011 at 14:12, Sandra Schlichting
<littlesandra88@gmail.com> wrote:
>> How is this advantageous over dmcrypt-LUKS?
>
> TRIM pass-through for SSD's. With dmcrypt on an SSD write performance
> is very slow.

Good point.  I'm actually very close to moving from magnetic to SSD
storage for my btrfs volumes.  Would my luks layer offset the majority
of any advantage I might otherwise see from SSD?  I'd be happy just to
eliminate seektime.

> cryptsetup-1.4.0-1 have --enable-discards option to allow
> discards/TRIM, but it is not recommended for theoretical security
> reasons.
>
> From my understanding some btrfs features wouldn't work with dmcrypt,
> like "online volume growth and shrinking"?

I've been using btrfs on luks now for 6 months and online grow works
fine -- if you online grow the luks container first. (cryptsetup
resize <name>)  It does make it a more manual process, I suppose, but
for me it's worth knowing that no part of the filesystem, will ever be
available should a disk be stolen.
