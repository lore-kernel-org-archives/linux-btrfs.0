Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:61381 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbaHYCJv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 22:09:51 -0400
Received: by mail-qg0-f42.google.com with SMTP id j5so12662943qga.15
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 19:09:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGQ70ev-a4QbJzxx+uurT+ZgX17TpzWQg=FrhL6BHu+j0a_ZWw@mail.gmail.com>
References: <CAGQ70evg4N0dU1-hycjQYbUDUwfnH_akTEcNTtAf=2rjtDU7NA@mail.gmail.com>
	<pan$36b2f$b7fa7666$7edd97f3$7ace6746@cox.net>
	<CAGQ70euehc2=Q9rRJ1zk7HzobDsbBg8QnVi=-2t3Zhn35xLRzA@mail.gmail.com>
	<441201408902401@web23m.yandex.ru>
	<pan.2014.08.24.18.08.12@googlemail.com>
	<CAGQ70ev-a4QbJzxx+uurT+ZgX17TpzWQg=FrhL6BHu+j0a_ZWw@mail.gmail.com>
Date: Mon, 25 Aug 2014 10:09:49 +0800
Message-ID: <CAGQ70ethmJwvMOCzOLMMnML65sUkGiog9Ek6DB_HaH9V9MVQJg@mail.gmail.com>
Subject: Re: 6+ MiB/s constant usage on a btrfs volume with kernel 3.16
From: Oon-Ee Ng <ngoonee.talk@gmail.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 25, 2014 at 8:05 AM, Oon-Ee Ng <ngoonee.talk@gmail.com> wrote:
> On Mon, Aug 25, 2014 at 2:08 AM, Holger Hoffstätte
> <holger.hoffstaette@googlemail.com> wrote:
>>
>> iosnoop:
>> http://www.brendangregg.com/blog/2014-07-16/iosnoop-for-linux.html
>>
>> Probably either a continuing balance or autodefrag vs. systemd's logging.
>
> Thank you, I'll try that out.
http://tny.cz/da4d5338 shows the problem, and for comparison this is a
30 second iosnoop log from 3.15.8 where I do not experience this issue
http://pastebin.com/8EjKiAuf
