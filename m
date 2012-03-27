From: Christoph Groth <cwg@falma.de>
Subject: Re: btrfs csum failed, scrub ok
Date: Tue, 27 Mar 2012 13:55:17 +0200
Message-ID: <87d37yw95m.fsf@falma.de>
References: <87haxawbtw.fsf@falma.de> <20120327170805.3df5e98f@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov <rm@romanrm.ru> writes:

> On Tue, 27 Mar 2012 12:57:31 +0200
> Christoph Groth <cwg@falma.de> wrote:
>
>> root@mim:/# find / -inum 453509 -ls
>> 453509 1976 -rw-r--r--   1 root     root      2020832 Mar  7 21:11 /usr/lib/libreoffice/basis3.4/program/libsblx.so
>> 
>> That file seems to be ok, there are no errors when re-reading it.
>
> How about
>
> $ sudo apt-get install debsums
> $ debsums libreoffice-core | grep libsblx.so

Good idea!

$ debsums libreoffice-core | grep libsblx.so
/usr/lib/libreoffice/basis3.4/program/libsblx.so                              OK

I'm still puzzled by this incident.

Christoph

