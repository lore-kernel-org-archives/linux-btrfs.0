From: Sandra Schlichting <littlesandra88@gmail.com>
Subject: Re: Encryption implementation like ZFS?
Date: Sat, 31 Dec 2011 15:00:19 +0100
Message-ID: <CAELiMBOzsZazJsWKA7ZqcBTF4DyrFGDo0=fdvW7X8WaaN1p7bw@mail.gmail.com>
References: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>
	<CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com>
	<CAELiMBP9g52fHQv=ur0Kjk+=kO9DWJMCh20RL+-2s_0pS7GVXg@mail.gmail.com>
	<CAG1y0sfD=AkD9VDf1=Njk9nyk_y+n3Pz9KEZSXevFzTUn7GwyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Billy Crook <billycrook@gmail.com>, linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sfD=AkD9VDf1=Njk9nyk_y+n3Pz9KEZSXevFzTUn7GwyA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> ... and depending on which SSD you use, it shouldn't matter. Really.
>
> Last time I tried with sandforce SSD + btrfs + -o discard, forcing
> trim actually made things slower. Sandforce (and probably other modern
> SSD) controllers can work just fine even without explicit trim fs
> support.

What command did you use to test this?

I have an OCZ Agility 3 SSD, which have the latest Sandforce
controller, so I would really like to try reproduce your test setup.
