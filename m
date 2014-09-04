Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58955 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbaIDJuY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Sep 2014 05:50:24 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: Zooko Wilcox-OHearn <zooko@leastauthority.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: fs corruption report
Date: Thu, 04 Sep 2014 11:50:14 +0200
Message-ID: <3487607.QJCBo4siRK@fb07-iapwap2>
In-Reply-To: <1409799655.13046.16.camel@localhost.localdomain>
References: <CAM_a8JxJBFQykuF13UF1Fi9jbM-=yromXbQ5PrWM5JPR7u6pXA@mail.gmail.com> <CAM_a8Jy3kwxtDvJ36T0hVrGRBbOK34MOEqZY0GhUUyAUHJMnCw@mail.gmail.com> <1409799655.13046.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart74233430.8Rm6rAqyM1"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart74233430.8Rm6rAqyM1
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

Hello Guy,

Am Donnerstag, 4. September 2014, 11:00:55 schrieb Gui Hecheng:
> On Mon, 2014-09-01 at 15:25 +0000, Zooko Wilcox-OHearn wrote:
> > I'm more than happy to try out patches and even focus my own brain on
> > diagnosing it, if I can. I'm hoping to regain access to some of my
> > files on my btrfs partition, and also I would enjoy helping get this
> > improved. :-)
> > 
> > So if you want me to try an experiment, just email me. Unfortunately I
> > can't just give you a copy of the partition, since it has confidential
> > information on it.
> > 
> > Regards,
> > 
> > Zooko
> 
> Hi Zooko, Marc,
> 
> Firstly, thanks for your backtrace info, Marc.
> Sorry to reply late, since I'm offline these days.
> For the restore problem, I'm sure that the lzo decompress routine lacks
> the ability to handle some specific extent pattern.
> 
> Here is my test result:
> I'm using a specific file for test
> /usr/lib/modules/$(uname -r)/kernel/net/irda/irda.ko.
> You can get it easily on your own box.
> 
> 	# mkfs -t btrfs <dev>
> 	# mount -o compress-force=lzo <dev> <mnt>
> 	# cp irda.ko <mnt>
> 	# umount <dev>
> 	# btrfs restore -v <dev> <restore_dir>
> report:
> 	# bad compress length
> 	# failed to inflate

uh, that's really odd. I don't use force compress, but I guess it will also 
happen with non-forced one if the file is big enough.

> btrfs-progs version: v3.16.x
> 
> With the same file under no-compress & zlib-compress,
> the restore will output a correct copy of irda.ko.
> 
> I'm not sure whether the problem above has something to do with your
> problem. Hope that the messages above are helpful.

I also get lot's of "bad compress length", so it might be indeed related.

I'm not a programmer, but is it possible that we are just skipping the lzo 
header (magic + header len + rest of header)?

Thanks,

Marc

--nextPart74233430.8Rm6rAqyM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJUCDXWAAoJEKyeR39HFBtoVmIH/2FmBeGU+CjZoeyIO0gGQHnF
LOWu7No8yC4uOYaVDNevnKArJ+GwfRO17rOOcKmM2b/GBDuEGZYfyamK9rRAKPHx
OoUpHKR2PLM2zcHvIldNX939g5+YGgZycA5Nsph8xw7syF4NC/McO2JKKDqWcjQh
qOM5vFCF/Zf/bzolgNrN/TcKSR9uCz6s1gMzLnZ7f28VPjffXL7KUY0xmJXn4Ww3
kbF4k9G+7847RCBT7pw6ZQsOX8asPkYcADpftVjQkBhp+Rjgcng2MrFgjfMrsgpX
Yb0IfamfFfe+pG35tKWb79uxU6E72aBbIUNtQFjIdxaKgB9asx8LiBUZv7kA1K4=
=HEYl
-----END PGP SIGNATURE-----

--nextPart74233430.8Rm6rAqyM1--

