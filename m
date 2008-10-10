From: "Andrea Gelmini" <andrea.gelmini@gmail.com>
Subject: Re: different oops
Date: Fri, 10 Oct 2008 12:49:53 +0200
Message-ID: <9cdbb57f0810100349w47cfff29pd12da1c110838c23@mail.gmail.com>
References: <200810031814.06897.mbuerger@edu.uni-klu.ac.at>
	 <9cdbb57f0810070804i1dfdedarc59d3d9189d621d5@mail.gmail.com>
	 <1223395385.16546.124.camel@think.oraclecorp.com>
	 <9cdbb57f0810070936s707f2aeek8f057e2c19efcd95@mail.gmail.com>
	 <9cdbb57f0810081451y66c0d780kccb6164fdfab287a@mail.gmail.com>
	 <1223511108.7014.39.camel@think.oraclecorp.com>
	 <9cdbb57f0810090120v6381ab0eg5377039b0065e68@mail.gmail.com>
	 <1223575532.14090.39.camel@think.oraclecorp.com>
	 <48EE6B50.6090102@oracle.com>
	 <9cdbb57f0810100145p5633210clf4814c45403b063b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Yan Zheng" <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <9cdbb57f0810100145p5633210clf4814c45403b063b@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2008/10/10 Andrea Gelmini <andrea.gelmini@gmail.com>:
> 2008/10/9 Yan Zheng <zheng.yan@oracle.com>:
>> Andrea, did you create swap file on btrfs?
> No, but Azureus (see my other email) plays a lot with holes.

Well, I try to extend my previous reply (in the meanwhile it crashed
again (kernel) with a newly added file).
I've got no "unsual" usage of my btrfs partition (is a /home on a
logical volume, over a dm-crypted /dev/sda3 partition).
The process able to trigger the crash is Azureus.
The "unusual" work of it, respect the other programs I run, is its
creation of file with lots of hole.
When I start to download movies (ehm... iso images of linux
distribution...), it does this:
first chunk (1~4MB) --- big big big holes (for ~1GB) --- last chunk (1~4MB)
then, while downloading, it replaces holes with real data (in a random
way, of course).

Well, I could try to allocate all space at the time creation.
Anyway, today I'll switch to 2.6.27 and new btrfs layout, so I
postpone this try after.

Thanks a lot for your time,
Andrea
