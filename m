Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:53858 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbaHYAGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 20:06:00 -0400
Received: by mail-qa0-f53.google.com with SMTP id v10so11611054qac.26
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 17:05:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan.2014.08.24.18.08.12@googlemail.com>
References: <CAGQ70evg4N0dU1-hycjQYbUDUwfnH_akTEcNTtAf=2rjtDU7NA@mail.gmail.com>
	<pan$36b2f$b7fa7666$7edd97f3$7ace6746@cox.net>
	<CAGQ70euehc2=Q9rRJ1zk7HzobDsbBg8QnVi=-2t3Zhn35xLRzA@mail.gmail.com>
	<441201408902401@web23m.yandex.ru>
	<pan.2014.08.24.18.08.12@googlemail.com>
Date: Mon, 25 Aug 2014 08:05:59 +0800
Message-ID: <CAGQ70ev-a4QbJzxx+uurT+ZgX17TpzWQg=FrhL6BHu+j0a_ZWw@mail.gmail.com>
Subject: Re: 6+ MiB/s constant usage on a btrfs volume with kernel 3.16
From: Oon-Ee Ng <ngoonee.talk@gmail.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 25, 2014 at 2:08 AM, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:
> On Sun, 24 Aug 2014 19:46:41 +0200, Flash ROM wrote:
>
>>> Happens a 100% of the time here, annoyingly. As mentioned, 3.15 was
>>> working for me, and still does. Multiple reboots and it happens
>>> immediately on boot even before gdm comes up.
>> Would be logical to do block-level I/O tracing to get idea WHAT is this
>> IO, right?
>
> Or you could just use proper tools for this:
>
> iotop:
> http://guichaz.free.fr/iotop/

iotop already done, showed in the attached picture. I understand not
all would want to load a pic, so the summary for iotop is that all the
I/O is allocated to a kworker thread. The same attached picture also
shows perf top for that pid, which I do not know how to interpret.
https://db.tt/TSh5piq6
>
> iosnoop:
> http://www.brendangregg.com/blog/2014-07-16/iosnoop-for-linux.html
>
> Probably either a continuing balance or autodefrag vs. systemd's logging.

Thank you, I'll try that out.
