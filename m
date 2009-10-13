From: Florian Weimer <fweimer@bfk.de>
Subject: Re: Mass-Hardlinking Oops
Date: Tue, 13 Oct 2009 07:07:54 +0000
Message-ID: <824oq3eppx.fsf@mid.bfk.de>
References: <4A74401B.90801@mccme.ru> <20090803145741.GC3765@think>
	<4A76FB78.5000207@wpkg.org> <20090803235920.C13173@mccme.ru>
	<87my3y3r8u.fsf@faran.nsc.liu.se>
	<3d0408630910111543t23bdf6c3u2274efc65f0fe06c@mail.gmail.com>
	<4AD2E3CF.6080701@wpkg.org> <20091012124726.GL2632@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
	"Yan\, Zheng " <yanzheng@21cn.com>,
	=?iso-8859-1?Q?P=E4r?= Andersson <paran@lysator.liu.se>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091012124726.GL2632@think> (Chris Mason's message of "Mon\, 12 Oct 2009 08\:47\:26 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

* Chris Mason:

>> Of course, not necessarily right now, but when you introduce some
>> other changes needing disk format change, please think of removing
>> the hard link limit as well.
>
> Please keep in mind this is only a limit on the number of links to a
> single file where the links and the file are all in the same director=
y.

So to work around this limit, I could do something like this?

  mkdir tmp.$$
  ln a tmp.$$/b
  ln tmp.$$/b .
  rm tmp.$$/b
  rmdir tmp.$$

(Instead of "ln a b".)

What am I missing?

--=20
=46lorian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstra=DFe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
