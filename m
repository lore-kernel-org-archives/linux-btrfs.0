From: Sandra Schlichting <littlesandra88@gmail.com>
Subject: Re: Encryption implementation like ZFS?
Date: Sat, 31 Dec 2011 15:12:43 +0100
Message-ID: <CAELiMBMc5ysTSqKSOgCeUq2imqPFmX=LoP3P8e0KEL07usNdQQ@mail.gmail.com>
References: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>
	<CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com>
	<CAELiMBP9g52fHQv=ur0Kjk+=kO9DWJMCh20RL+-2s_0pS7GVXg@mail.gmail.com>
	<CANZ96zXurbiy=WOOmULcs13fiQomuw=WzDtqm-KFptCx_4TA5A@mail.gmail.com>
	<20111231095331.GA2829@scooter>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Billy Crook <billycrook@gmail.com>, linux-btrfs@vger.kernel.org
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111231095331.GA2829@scooter>
List-ID: <linux-btrfs.vger.kernel.org>

> The advantage of loopaes is that it is more secure then luks and way faster.
> The speed with encryption (loopaes) is about 90-95% the speed without encryption at
> my setup.

Sounds very interesting. Will try that.

I case of my PC I would actually prefer a weaker encryption, as I am
not protecting my data from NSA, but from a person with a non-crypto
background, but I don't suppose btrfs will have such option =)

In terms of parallelization, would there be benefits of having the
encryption done by btrfs?
