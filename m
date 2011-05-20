From: Miguel Garrido <miguel@mjgar.com>
Subject: Re: What are thoses [btrfs-cache-nnn] kernel threads ?
Date: Fri, 20 May 2011 08:11:13 -0400
Message-ID: <BANLkTinpF-bW92w5R5z+5SYW_qBjJvyPBw@mail.gmail.com>
References: <4DD4825D.4060706@polymtl.ca>
	<20110519182612.GD18123@dhcp231-156.rdu.redhat.com>
	<BANLkTik5vAoZrY0H=y+2v5i91x8FvsxRYQ@mail.gmail.com>
	<BANLkTimRPE-roV8JaRhQpqQW_sMtsW7Gww@mail.gmail.com>
	<1305890412-sup-1052@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chester <somethingsome2000@gmail.com>,
	Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305890412-sup-1052@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 20, 2011 at 7:22 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Once enabled it does stay on, and strictly speaking it does change th=
e
> disk format. =A0But, it is perfectly safe to go back to a non-space_c=
ache
> enabled kernel and then go back into space cache. =A0Josef set things=
 up
> so it would detect a non-space_cache mount and continue properly.
>
> space_cache is wonderful. =A0We did fix up a few bugs in .38 and .39 =
but
> I'll probably have .40 enable it by default.
>
> -chris
>

Sounds good, I thought it just made more sense to have it on by
default if it is that beneficial but I now understand that the option
was introduced to give users a choice until it made sense to enable it
by default.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
