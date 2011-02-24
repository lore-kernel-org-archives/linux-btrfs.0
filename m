From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped buffer of the same page
Date: Thu, 24 Feb 2011 11:00:59 -0500
Message-ID: <1298563230-sup-9619@think>
References: <1291887014-18447-1-git-send-email-xin.zhong@intel.com> <201101280354.36884.johannes.hirte@fem.tu-ilmenau.de> <1865303E0DED764181A9D882DEF65FB685DF762B45@shsmsx502.ccr.corp.intel.com> <201102020034.43808.johannes.hirte@fem.tu-ilmenau.de> <1865303E0DED764181A9D882DEF65FB68621CA7167@shsmsx502.ccr.corp.intel.com> <1298028713.11103.13.camel@mainframe> <1865303E0DED764181A9D882DEF65FB686421B24FB@shsmsx502.ccr.corp.intel.com> <1298559118.11224.40.camel@mainframe> <AANLkTimkEGAGjY17FX_EFGwo6RJEoEfQ3WdKhNUymSE+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: =?utf-8?q?Maria_Wikstr=C3=B6m?= <maria@ponstudios.se>,
	"Zhong, Xin" <xin.zhong@intel.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTimkEGAGjY17FX_EFGwo6RJEoEfQ3WdKhNUymSE+@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Mitch Harder's message of 2011-02-24 10:55:15 -0500:
> 2011/2/24 Maria Wikstr=C3=B6m <maria@ponstudios.se>:
> > m=C3=A5n 2011-02-21 klockan 09:51 +0800 skrev Zhong, Xin:
> >> The backtrace in your attachment looks like a known bug of 2.6.37 =
which have already been fixed in 2.6.38. I have no idea why latest btrf=
s still hang in your environment if there's no debug info...
> >>
> >
> > Haha, yes that's very hard :)
> >
> > 2.6.38-rc6 and btrfs-unstable behaves the same way. I can close the
> > process with ctrl+c and it disappear a few seconds later. There is =
no
> > CPU usage. Reading works because I can start htop and watch "svn in=
fo"
> > disappear, but everything writing to btrfs slows down to a crawl. I=
t
> > takes about 1 minute to log in. So I had to put the logs on an othe=
r
> > partition using ext3 to get the output from sysrq+t.
> >
>=20
> I believe I've been experiencing this issue also.  However, my proble=
m
> usually results in a "No space left on device" error rather than a
> lock-up or crash.  But I've bisected my issue to this patch, and my
> "btrfs fi show" and "btrfs fi df" looks similar to others who've
> posted to this tread with all my space being allocated, but not used.
>=20

Sorry, which patch did you bisect the problem down to?

> I've been playing around with ftrace to try to get some information o=
n
> the issue.  Since I'm getting a soft error, I can used a command like
> "echo 1 > tracing_on; emerge -1av openmotif; echo 0 > tracing_on" to
> end the trace as soon as the build fails.
>=20
> The traces are probably too large for the M/L (~275kb compressed), so
> I've put them up on my local server in case anybody can find them
> useful:
>=20
> http://dontpanic.dyndns.org/emerge-openmotif-ftrace.gz
>=20
> I'm still only capturing the tail end of the problem, but maybe
> someone will find these insightful.
>=20
> Let me know if you want me to increase the ftrace buffer size or
> insert some trace_printk debugging statements.

Thanks, I'll take a look.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
