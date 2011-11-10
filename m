From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: How to remount btrfs without compression?
Date: Thu, 10 Nov 2011 06:57:07 +0000 (UTC)
Message-ID: <j9fsk3$f00$1@dough.gmane.org>
References: <4EB72C1B.1030702@parallels.com>
	<201111071319.14493.Martin@lichtvoll.de> <4EB87E01.1040704@parallels.com>
	<4EB880A0.1030304@gmail.com>
	<CAG1y0seMUUNwXCY6-=JehE+rrd4PRF55MZoHEUB_9+jDm6N_rA@mail.gmail.com>
	<4EB88BC9.7020509@gmail.com> <4EB88D4A.5050908@parallels.com>
	<20111108150151.GA4954@shiny> <20111108151208.GB4954@shiny>
	<4EB9D0D9.1000009@parallels.com> <j9db98$gbt$1@dough.gmane.org>
	<4EBA33DB.2070409@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Dmitry Olenin, Wed, 09 Nov 2011 17:03:39 +0900:

> On 11/09/2011 04:48 PM, Lubos Kolouch wrote:
>> Sorry for possibly OT question - when I have historical btrfs system
>> mounted with zlib compression,
>>
>> can I remount it with lzo ? What will happen? Will the COW be broken
>> and the files taking duplicate space? Or will the Universe explode and
>> be replaced with something even more bizzare?
> 
> Hello Lubos If you have a kernel that supports lzo (don't quite remember
> when it got in), why can't you?
> Absolutely nothing will happen, and only the new/updated files will be
> with lzo compression. You can remount on the fly switching b/w the two
> compression options without any problems.

Hello Dmitry,

By the way, this is interesting question to me - I mounted the filesystem
with -o compress=lzo, in dmesg showed btrfs: use lzo compression,

but - the lzo module was not loaded (not shown in lsmod - and yes, I have
it as a module).

When I do modprobe lzo, it shows there.

Isn't it a bit strange? So btrfs is using lzo module that was not loaded?
(and says so in the dmesg output)?

Thank you

Lubos

