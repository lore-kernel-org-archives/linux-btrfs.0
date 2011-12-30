From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Re: Re: Two way mirror in BRTFS
Date: Fri, 30 Dec 2011 23:45:37 +0700
Message-ID: <CAG1y0scUAHij+vUCUqOqCGMfaZwqiPNkt9cVZVc-4sVVMkc7Jw@mail.gmail.com>
References: <CAG1y0sf8D1Nfzz90Dn5yun6d9CYjvT6xoZGo5DE29OkguHVuAw@mail.gmail.com>
	<135550.23479.60309-2401-1978249025-1325258844@email.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: jaromir.zdrazil@email.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <135550.23479.60309-2401-1978249025-1325258844@email.cz>
List-ID: <linux-btrfs.vger.kernel.org>

2011/12/30 Jaromir Zdrazil <jaromir.zdrazil@email.cz>:
>> > And if I am not mistaken, current version does not yet support a mountable
>> filesystem.
>>
>> You're mistaken :) With some extra work, you can even use it as root:
>> - http://zfsonlinux.org/example-zpl.html
>> -
>> https://github.com/dajhorn/pkg-zfs/wiki/HOWTO-install-Ubuntu-to-a-Native-ZFS-Root-Filesystem
>>
> It seems I trust the web pages too much - in http://zfsonlinux.org/ is written that it does not ;O)) otherwise I would be using it already.

The web page is correct.
http://zfsonlinux.org/: "Please keep in mind the current 0.5.2 stable
release does not yet support a mountable filesystem. This
functionality is currently available only in the 0.6.0-rc6 release
candidate."
http://zfsonlinux.org/example-zpl.html: "However, all the core
functionality is in place and most of the advanced features are
working. Stability of the latest release candidates has been very good
and performance is respectible. Many people are successfully using the
ZFS on Linux release candidates."

Most zfsonlinux users use 0.6.0-rc6, and a big part of those is using
the easy-to-install package from ubuntu ppa.

>> Either way, neither zfs or the (planned) btrfs send/receive supports
>> two-way/active-active setup. Both should (or will) work just fine for
>> one-way replication.
>>
> That is what I needed to know! Thank you very much!

You're welcome.

-- 
Fajar
