From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: Re: btrfs and load (sys)
Date: Wed, 23 Nov 2011 16:08:48 +0100
Message-ID: <CAJ1PRSk4cker8WbSL5t9sKYde=f4XRAkQGQVYVC=8wnJKT8EwQ@mail.gmail.com>
References: <CAJ1PRSnhqo3yU4b0sbcYLfByb_pTDuAOL2xo4fryiEoacr8iYg@mail.gmail.com>
	<20111123205616.73b4d0a7@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111123205616.73b4d0a7@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

Yes, yesterday I've umouted partition and re-mounted it. Nothing has
changed this night.

You can look at my load graphs here:
http://img42.imageshack.us/img42/4661/33737291.png
http://img210.imageshack.us/img210/2742/46527625.png

On the second one blue is SYS load. I bet you can reasily spot time
when backup to btrfs partition was running :)

I doubt its a bug in btrfs. It is just broken concept :(


# uname -a
Linux sv15.vipserv.org 3.0.4-xxxx-std-ipv6-64 #1 SMP Mon Oct 10
01:07:40 CEST 2011 x86_64 x86_64 x86_64 GNU/Linux
