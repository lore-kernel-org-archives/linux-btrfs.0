From: "Andrea Gelmini" <andrea.gelmini@gmail.com>
Subject: Re: different oops
Date: Fri, 10 Oct 2008 10:43:34 +0200
Message-ID: <9cdbb57f0810100143w44f8d7b5n3bd3aa0a329356ec@mail.gmail.com>
References: <200810031814.06897.mbuerger@edu.uni-klu.ac.at>
	 <9cdbb57f0810070431w523f90eek63fd74e44add35cd@mail.gmail.com>
	 <1223384193.16546.111.camel@think.oraclecorp.com>
	 <9cdbb57f0810070804i1dfdedarc59d3d9189d621d5@mail.gmail.com>
	 <1223395385.16546.124.camel@think.oraclecorp.com>
	 <9cdbb57f0810070936s707f2aeek8f057e2c19efcd95@mail.gmail.com>
	 <9cdbb57f0810081451y66c0d780kccb6164fdfab287a@mail.gmail.com>
	 <1223511108.7014.39.camel@think.oraclecorp.com>
	 <9cdbb57f0810090120v6381ab0eg5377039b0065e68@mail.gmail.com>
	 <1223575532.14090.39.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1223575532.14090.39.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

2008/10/9 Chris Mason <chris.mason@oracle.com>:
> Yan,
>
> Can these leaf ref miss warnings trigger corruptions?  I thought not but
> its clear there is some metadata corruption here:
>
> Andrea, how exactly did you trigger this?

Nothing in particular, usual work session on my laptop.
It seems to be it was a problem with a newly created torrent file.
Well, no deep debug, simply some minutes after
Azureus started it crashed (kernel), always.
So I take new last file, copyed to tmpfs (without errors reading), and
re-copyed to btrfs.
The problem disappeared. Part of file was corrupted, but there was the
crash, azureus caching, and so on.
Anyway, comparing my /home with the external backup, I found no problem.

'Til now I have no evidence of data/metadata corruption.

Thanks a lot,
Andrea
