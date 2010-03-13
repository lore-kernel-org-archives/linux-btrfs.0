From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: resize
Date: Sat, 13 Mar 2010 12:23:38 -0800
Message-ID: <93cdabd21003131223q2922e75ape443d2dcbb265e5a@mail.gmail.com>
References: <d51192a01003121838x7bb813bem992d32bca75a1cd8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Brian Callender <brian@accipio.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <d51192a01003121838x7bb813bem992d32bca75a1cd8@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 12, 2010 at 6:38 PM, Brian Callender <brian@accipio.ca> wro=
te:
> Greetings,
>
> I estimate it has been 10 hours since I issued the command =C2=A0"btr=
fsctl
> -r -4g /home" to attempt to free some space for a new partition. It i=
s
> still running. How long should this take? I am very concerned about
> the integrity of my system. Is it safe to interrupt the process? It
> seems increasingly likely there is some problem.
>
> My btrfs tools version is 0,19. The fs is mounted with compress and
> ssd options. I am running kernel 2.6.32.
>

Is your system still responsive?  Check your kernel logs for oops or
warning messages.  I would suggest you retry with 2.6.33 as there have
been many improvements there.  Other than that, join the #btrfs irc
channel and more help can be done there.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
