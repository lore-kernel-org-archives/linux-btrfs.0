Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38150 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3LKIJI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 03:09:08 -0500
Date: Wed, 11 Dec 2013 08:09:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Imran Geriskovan <imran.geriskovan@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
Message-ID: <20131211080902.GI9738@carfax.org.uk>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com>
 <01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com>
 <CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com>
 <F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com>
 <CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com>
 <B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com>
 <CAK5rZE6G0WDf6rxjS7o9Cggq-CehASG1ge4bLnJm=SmHA40new@mail.gmail.com>
 <6FD125A9-7975-4C34-88C7-95B11A39D054@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZVh52eu0Ophig4D"
In-Reply-To: <6FD125A9-7975-4C34-88C7-95B11A39D054@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--YZVh52eu0Ophig4D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 10, 2013 at 09:07:21PM -0700, Chris Murphy wrote:
> 
> On Dec 10, 2013, at 8:19 PM, Imran Geriskovan <imran.geriskovan@gmail.com> wrote:
> > 
> > Now the question is, is it a good practice to use "-M" for large filesystems?
> > Pros, Cons? What is the performance impact? Or any other possible impact?
> 
> Uncertain. man mkfs.btrfs says "Mix data and metadata chunks together for more efficient space utilization.  This feature incurs a performance penalty in larger filesystems.  It is recommended for use with filesystems of 1 GiB or smaller."

   That documentation needs tweaking. You need --mixed/-M for larger
filesystems than that. It's hard to say exactly where the optimal
boundary is, but somewhere around 16 GiB seems to be the dividing
point (8 GiB is in the "mostly going to cause you problems without it"
area). 16 GiB is what we have on the wiki, I think.

> I haven't benchmarked to quantify the penalty.

   Nor have I.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                      --- vi: The core of evil. ---                      

--YZVh52eu0Ophig4D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUqgdnlheFHXiqx3kAQIlyQ/7B/T4whPSNzBi+vNTlWS8s1BgFQffYs9u
acYooeojeHBSvgBtTXcURLWPt3NBpvakKaaPZBqw/xE2RVTUEgFoSDNU40tQXJm3
1bnIx8DLgXOj1g/qBmZIDHFnc1ytJ2JmIsH0MxyyhTIReDl56PE/u9P2yjpk+glj
BjqIZu58qSttqqi1r9jHTBhgZ1mdA9NnNNmIOqy676WunHquJfZwX73cokg2YGpU
z3XfJltJnYHjoLx1gpII+E9s9ZlDb96PhBZGKTWkauguVCvKvvuXrLw62eruk7Dq
ym9VDV9WeC6wU/oMVxXyp777NUEBau7fxuBvadpk3Vteyp2awIzG7HI2ISDvhdJX
wj7HD8tS6XOeWp1UeQtsgKm/4zWP2g+BIhHT5iDolwlofmqzsKHis+ATSqBagDWx
XVcJAXfd1Vk6WnIoN0lyiqWO/Mvvn0QsoA5SRNyK6NdaIcDlCcAUvIOCkZ6jTi6d
y5R3Nq6TsjLhdASHmBWsH2G0n9HoTCjrnba+KQMOX9AZUQMjH6W/7R33mjXip78Z
9+xYuUk0T1cVD+b2vSVn/3zRsUo7ou1Vai/XsN4sAv3qu9t4re54qdQDP3+utD+V
UbzfrroLCgCSl5jxqX9NlXChUR3pJVJz/0x+WfVx1q9FKTNoytbtnU4FDg4P2tRr
4x3I0fsmOxA=
=hC7G
-----END PGP SIGNATURE-----

--YZVh52eu0Ophig4D--
