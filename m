From: "Morten P.D. Stevens" <mstevens@imt-systems.com>
Subject: Re: btrfs benchmark with 2.6.37-rc1
Date: Mon, 1 Nov 2010 16:12:54 +0100
Message-ID: <AANLkTi=ZdhiH2RsEVx8EM6L6XApm2-dyeq_=t+Vuk8Ck@mail.gmail.com>
References: <AANLkTinp=wsayqczkpDB-75MedEpC0Z49FqM2dyFGG4x@mail.gmail.com>
	<AANLkTikxKZ4gwtPqfPFvkMh2FqVBHrUOA2UzW7Uf_pHi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikxKZ4gwtPqfPFvkMh2FqVBHrUOA2UzW7Uf_pHi@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/11/1 cwillu <cwillu@cwillu.com>:

>
> Can you include the mkfs and mount options in use?

mkfs.btrfs /dev/sdb
mount -t btrfs /dev/sdb /mnt/btrfs

and for ext4:

mkfs.ext4 /dev/sdb
mount -t ext4 /dev/sdb/ mnt/btrfs

Best regards,

Morten
