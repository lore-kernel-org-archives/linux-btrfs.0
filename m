Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.30.189.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003672;
	b=b8BGbBMDKdogC9xg61aBn6ynz1Ph76eVmDeJGlt8B2zzLXh4b41Bao72gEKeMbbkQk9/
	 pqsnzUI+4W784bXoQ6C10uNblgphcAYkf2r2PXIGiE38rLxoTmQduvK5gb9VTyG2noPQB
	 9SktyY91kvvPubU8H56zRcCg9ebkloavrd6vbKaP6H8Q9Jiti1H8aZOwAZkIx1aZHLvK4
	 78LbZuI+8FSdZY4Mxs04noLER649UdmHa5I4poUAhjJ+TCOOCUm2oL6c45Ree9WohwwDQ
	 5RAj4Wj7LhYu0jqjLUQ4B0my42/JKcxoMQaTiANboR/FbxRIvvt2xEy5IoUEe7sD7vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003672;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eXVjFFgBInvFAm4DxkHovG+TVQ/ZQK5DJW5eaL/Ya/4=;
	b=4CehwvsZ7YZ49J/EUSFw7GiuerAYs9YGbIMjb/ToHeBndbETAymv/z0UBbBC3dy9qEr8
	 7sz9jQ14b7/Yu6yN7irg+1hgqywE97p1sqqhjkYnf64sgaB19n6eWaAfbPfnh6MgEvQeI
	 N86eahL+YcHDXci9Zn2lOnjFt5aOGDvLn2ZXxZsvf70zVKBkHrAS+12qiMPZzJ6GyfaIE
	 Eq6uGcEY3xtM5dWlnxJvKFed+6iRNbM6ZyebRuembt9R++17/9ldChfYYmeYguZDf3hGa
	 flf10aIjEMbkALKCx2GdVRymWdJ4Sox2yR6Qnsffc9NQ4GUr3j8bC8ZCnysqgUIor0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iodev.co.uk;
	spf=pass smtp.mailfrom=iodev.co.uk;
	arc=none smtp.remote-ip=46.30.189.100
Received: from iodev.co.uk (iodev.co.uk [46.30.189.100])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE87606A325;
	Wed, 18 Nov 2026 12:07:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AE87606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iodev.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iodev.co.uk
Received: from pirotess (unknown [79.116.217.174])
	by iodev.co.uk (Postfix) with ESMTPSA id E1A005E3F92;
	Wed, 18 Nov 2026 13:07:43 +0100 (CET)
Date: Wed, 18 Nov 2026 13:07:42 +0100
From: Ismael Luceno <ismael@iodev.co.uk>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-kernel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, Chris Mason
 <mason@kernel.org>, Christian Brauner <brauner@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/8] btrfs: assemble a multi-device root filesystem
 without an initrd
Message-ID: <20261118130742.4378354e@pirotess>
In-Reply-To: <ce9f04e8-a5e6-478b-acf7-e2ad56e0c456@gmx.com>
References: <20261116224316.11237-10-ismael@iodev.co.uk>
	<fc1f9f58-71ad-410e-bf03-8b27e607ab76@suse.com>
	<20261117183643.36afff2b@pirotess>
	<ce9f04e8-a5e6-478b-acf7-e2ad56e0c456@gmx.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Nov 2026 06:30:31 +1030
Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> =E5=9C=A8 2026/11/18 04:06, Ismael Luceno =E5=86=99=E9=81=93:
> > On Tue, 17 Nov 2026 10:11:46 +1030
> > Qu Wenruo <wqu@suse.com> wrote:
> >> =E5=9C=A8 2026/11/17 09:13, Ismael Luceno =E5=86=99=E9=81=93:
> >>> A multi-device btrfs root filesystem is normally assembled by the
> >>> device scanner that an initrd runs before mounting the root.
> >>
> >> What is the problem here?
> >>
> >> Is generating an initramfs really that complex?
> >=20
> > Why depend on an initramfs?
>=20
> Why not? One should not put everything into kernel.
>=20
> E.g. what if the customer has some custom udev rules for devices
> names? Now they can not use the custom devices names during boot,
> which they can before.
>=20
> Shouldn't this count as a regression?

I don't think that's a possibility since the initramfs takes precedence,
everything would follow the same sequence as before the patch.

If anything it makes the boot process more consistent and enables
migrating initramfs-less systems to a multi-device setup without
changes to the boot process, which was my main goal (unfortunately all
the generators produce bloated initramfs', and I didn't want to
introduce yet another implementation just for this, plus it would be
slower anyway).
