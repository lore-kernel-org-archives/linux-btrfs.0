From: "Andrea Gelmini" <andrea.gelmini@gmail.com>
Subject: Re: different oops
Date: Tue, 7 Oct 2008 13:31:09 +0200
Message-ID: <9cdbb57f0810070431w523f90eek63fd74e44add35cd@mail.gmail.com>
References: <200810031814.06897.mbuerger@edu.uni-klu.ac.at>
	 <200810032222.42054.mbuerger@edu.uni-klu.ac.at>
	 <1223065590.13375.68.camel@think.oraclecorp.com>
	 <9cdbb57f0810031509m35c71919s965778dc6cb0ec5f@mail.gmail.com>
	 <20081004003129.GC8449@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081004003129.GC8449@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

2008/10/4 Chris Mason <chris.mason@oracle.com>:
>> I'm going to try to use the cloned partition as my new /.
>> Is there something dangerous other the ENOSPC?
>
> We don't have known big bugs right now, but you'll need to use another
> FS on /boot.

I use initd, so no problem.
Anyway, I started using btrfs for my /home (before it was Reiserfs3).
Well, after few days of usage, the good news is about no problem like
crash, file corruption, and so on. It also worked well with TuxOnIce,
with a lot of suspend/resume cycle. The bad news is about load
average. In normal session (WindowMaker, Firefox, Kopete, Skype,
Konsole, Evince, Azureus, Evolution, K3B) I've a lot higher load
average respect Reiserfs3. The worst is using mirrordir to backup
/home on external device (load avg > 10).
Is it a normal work in progress, or does it happens only to me?
My /home is over dm-crypt, by the way.

Thanks a lot for your time,
Gelma
