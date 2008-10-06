From: Martin =?iso-8859-1?q?B=FCrger?= <mbuerger@edu.uni-klu.ac.at>
Subject: Re: space info full
Date: Mon, 6 Oct 2008 22:28:24 +0200
Message-ID: <200810062228.24310.mbuerger@edu.uni-klu.ac.at>
References: <200810040945.56118.mbuerger@edu.uni-klu.ac.at> <20081006182723.GB2840@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081006182723.GB2840@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 06 October 2008, Josef Bacik wrote:
> are you running the latest git trees of both btrfs-unstable and
> btrfs-progs-unstable? =A0I'd expect BUG()'s or something like that,
> shouldn't be getting hangs. =A0Thanks,

Yes, I used both unstable versions from the git tree for the tests.=20
No further messages than the one I mentioned occurred. Furthermore=20
the system did hang at any operation on that particular file system=20
after (can not exactly tell when) the 'space info full' message had=20
turned up. Unfortunately I've not been able to reproduce this (yet),=20
hence this might have been an issue with the virtual machine=20
(VMWare) I using for the tests.

Regards,
--=20
Martin B=FCrger
1024D/27C9019B@www.edu.uni-klu.ac.at/~mbuerger/key.asc
Key fingerprint =3D D10D 97EF 0C32 B337 5A12  0B6C 2D47 7575 27C9 019B
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
