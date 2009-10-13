From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Mass-Hardlinking Oops
Date: Tue, 13 Oct 2009 15:28:15 +0800
Message-ID: <3d0408630910130028r148c5eddte2a4451bfbc2e8eb@mail.gmail.com>
References: <4A74401B.90801@mccme.ru> <20090803145741.GC3765@think>
	 <4A76FB78.5000207@wpkg.org> <20090803235920.C13173@mccme.ru>
	 <87my3y3r8u.fsf@faran.nsc.liu.se>
	 <3d0408630910111543t23bdf6c3u2274efc65f0fe06c@mail.gmail.com>
	 <4AD2E3CF.6080701@wpkg.org> <20091012124726.GL2632@think>
	 <824oq3eppx.fsf@mid.bfk.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	=?ISO-8859-1?Q?P=E4r_Andersson?= <paran@lysator.liu.se>,
	linux-btrfs@vger.kernel.org
To: Florian Weimer <fweimer@bfk.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <824oq3eppx.fsf@mid.bfk.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 13, 2009 at 3:07 PM, Florian Weimer <fweimer@bfk.de> wrote:
> * Chris Mason:
>>> Of course, not necessarily right now, but when you introduce some
>>> other changes needing disk format change, please think of removing
>>> the hard link limit as well.
>>
>> Please keep in mind this is only a limit on the number of links to a
>> single file where the links and the file are all in the same directo=
ry.
> So to work around this limit, I could do something like this?
> =A0mkdir tmp.$$
> =A0ln a tmp.$$/b
> =A0ln tmp.$$/b .

If "ln a b" doesn't work,  this "ln" won't either.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
