Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbbBBE65 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 Feb 2015 23:58:57 -0500
Date: Mon, 2 Feb 2015 15:58:43 +1100
From: NeilBrown <neilb@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: __might_sleep() warnings on v3.19-rc6
Message-ID: <20150202155843.5991a10c@notabene.brown>
In-Reply-To: <20150202100338.4fa9eefa@notabene.brown>
References: <20141028142541.GA19097@wfg-t540p.sh.intel.com>
	<20150201034315.GA20124@wfg-t540p.sh.intel.com>
	<20150202100338.4fa9eefa@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/iDmEtqUMulV6XzoywgT5Fty"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/iDmEtqUMulV6XzoywgT5Fty
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


(high-jacking the thread a bit... I don't have the patch that I want to rep=
ly
to still in my mail box:  the subject still matches...)

I just got a might-sleep warning in my own testing.
This was introduced by=20

commit e22b886a8a43b147e1994a9f970f678fc0df2033
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Wed Sep 24 10:18:48 2014 +0200

    sched/wait: Add might_sleep() checks


In particular:

@@ -318,6 +320,7 @@ do {                                                   =
    =20
  */
 #define wait_event_cmd(wq, condition, cmd1, cmd2)                      \
 do {                                                                   \
+       might_sleep();                                                  \
        if (condition)                                                  \
                break;                                                  \
        __wait_event_cmd(wq, condition, cmd1, cmd2);                    \


Where I call this in raid5_quiesce(), 'cmd1' releases a lock and enables
interrupts and  cmd2 takes the lock and disables interrupts.

So it is perfectly OK to sleep at the point where schedule is called, but n=
ot
at the point where wait_event_cmd is called.

I can't use wait_event_lock_irq_cmd() as there are actually several spinloc=
ks
I need to manipulate.

So I'm hoping that this part of the patch (at least) can be reverted.

Otherwise I guess I'll need to use __wait_event_cmd().

Thanks,
NeilBrown

--Sig_/iDmEtqUMulV6XzoywgT5Fty
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVM8EAznsnt1WYoG5AQKQXQ//cKbxdLF0oju54f+wJp3BjocLwxET9tDS
iMT4vqMiWTXnrVIwrmpaJug4fE4mXjX4HBnHAhcRXTvSfL5GBh5CncaJWL7s/g9U
cre856fTQnthcWZVdXJ9yxFn7P8oAtPr2UwE8nHN+c1YjNy6hLu/2wZQJGs4q92b
qUXiW0mjhKYO54tGaq4PeTewxUBqgzojX/Yzgmc1T4x4sIF0YFXg+SvOQBt+ycz9
wpINN6A/BHr8fSp9gy1nKNrpizN0bnzZjnWqXHmp1PxeVFnY3SBA6bJiWE2UQz3J
OGsfZGIHpxYywvkWUelIt/uSBfszZCYEQl49nw910EKcMvoI2sqllRpgnYQe2aQB
QIKkk/QjrreLW0mQG/nQYt4J/+8gLo42sdpXnVYW9Wx6AhaJkCPKCkDQCjClvlOr
nt6v43dcXPgpG0DMy5M1/SZBBIM2Pnr/FHVe9BhqY7fHFrwCTLsghhIXFUgxBwjD
YKL2EDxGaR58WWBNRH8p6rvyXfTlUIGF4f8SEgxkDXuRWpnQuMkcuS40Tql7r8gg
BotD3iJyFu5acsB1AAWA1gFggwpZEzGD3zwgd0nykdpDuWvEpuivKrQ8m0M949+6
vL3/bttx6uqF7c8fbmVFfIaJRPoJd/KAzYWuCDhOvS53JBRjqOHtLB+FfuRPQQYk
PMy20kmsmCg=
=mrSD
-----END PGP SIGNATURE-----

--Sig_/iDmEtqUMulV6XzoywgT5Fty--
