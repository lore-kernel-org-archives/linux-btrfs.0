From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [PATCH 2/2] Btrfs-progs: Add hot data support in mkfs
Date: Wed, 1 Sep 2010 13:56:49 +0200
Message-ID: <201009011356.51609.hka@qbs.com.pl>
References: <1281652177-23562-1-git-send-email-bchociej@gmail.com> <20100813131422.GA615@centrinvest.ru> <AANLkTinQAa=DujQ2Tm1oi2kVqF9z1RX2_M3SCCO_MKZG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	cmm@us.ibm.com, bcchocie@us.ibm.com, mrlupfer@us.ibm.com,
	crscott@us.ibm.com, mlupfer@gmail.com, conscott@vt.edu
To: Ben Chociej <bchociej@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTinQAa=DujQ2Tm1oi2kVqF9z1RX2_M3SCCO_MKZG@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 13 August 2010 16:10:24 Ben Chociej wrote:
> It's a good point, of course. Ideally we would be able to prioritize
> data and place them on 15k versus 7.2krpm disks, etc. However you get
> to a point where's there's only incremental benefit. For that reason,
> the scope of this project was simply to take advantage of SSD and HDD
> in hybrid. Of course, you could register the same complaint about the
> ZFS SSD caching: why not take advantage of faster vs. slower spinning
> disks? Unfortunately it just wasn't in the scope of our 12-week
> project here.
>=20
> That's not to say it *shouldn't* be done in the future, of course!
> And, incidentally, you could hack it together at this point by settin=
g
> the /sys/block/<blockdev>/queue/rotational flag to 0 and using it lik=
e
> an SSD. :)

Then why not make the devices with rotational at 0 be the default "SSDs=
" but=20
allow the admin to set manually others, without hacking?

You can have SSDs in a hardware RAID array, this way the kernel may not=
 know=20
if the block device is on flash media or on rotational media...

--=20
Hubert Kario
QBS - Quality Business Software
ul. Ksawer=F3w 30/85
02-656 Warszawa
POLAND
tel. +48 (22) 646-61-51, 646-74-24
fax +48 (22) 646-61-50
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
