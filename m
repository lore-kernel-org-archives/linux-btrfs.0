From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: How to remount btrfs without compression?
Date: Tue, 8 Nov 2011 08:52:03 +0700
Message-ID: <CAG1y0seMUUNwXCY6-=JehE+rrd4PRF55MZoHEUB_9+jDm6N_rA@mail.gmail.com>
References: <4EB72C1B.1030702@parallels.com>
	<201111071319.14493.Martin@lichtvoll.de>
	<4EB87E01.1040704@parallels.com>
	<4EB880A0.1030304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: dima <dolenin@parallels.com>, linux-btrfs@vger.kernel.org
To: Eric Griffith <egriffith92@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EB880A0.1030304@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 8, 2011 at 8:06 AM, Eric Griffith <egriffith92@gmail.com> wrote:
> Edit your
> fstab, remove the compress flag, reboot. Tell btrfs to rebalance the system,
> reboot again. And I -THINK- that'll decompress all the files

I think the original question was how to force uncompressed mode,
whether specific to a file or to a whole filesystem, without having to
reboot :)

AFAIK there's no way to do that.

-- 
Fajar
