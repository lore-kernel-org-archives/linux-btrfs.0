From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Re: corrupted btrfs after suspend2ram uncorrectable with scrub
Date: Tue, 01 Nov 2011 19:57:13 -0200
Message-ID: <orzkgfwlom.fsf@livre.localdomain>
References: <CANkykrA7uxc51rFTbTXar8v_3vE2Gn9LKYrApOfvqWNf5B_adw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Gustavo Sverzut Barbieri <barbieri@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANkykrA7uxc51rFTbTXar8v_3vE2Gn9LKYrApOfvqWNf5B_adw@mail.gmail.com>
	(Gustavo Sverzut Barbieri's message of "Tue, 1 Nov 2011 16:38:29
	-0200")
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Gustavo,

On Nov  1, 2011, Gustavo Sverzut Barbieri <barbieri@gmail.com> wrote:

>   btrfs csum failed ino 2957021 extent 85041815552 csum 667310679
> wanted 0 mirror 0

> Is there any way to recover it?  :-S

Did you try mounting without data checksums?

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
