Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.30.189.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937008;
	b=XLhZULAE/UmDopTdiInGwpWPmEcESnmYwcRyx8V2w99OmWHBzWIYoMF9eKyA+YrA+obE
	 7K2QuYQ4/bp9zGgJfAWMG00ex+x96ijVZ/ZfKL4od7tkvfx2RXbApu3tt3UJUse3NnAzX
	 Y7n8PrLzkZtEBPhjQwb77SOj3kOw2deay33fURtJ3gFnOlDE7/xq6+mLG4dAa2Y9bGl08
	 gqGN7OKcLUnasKN4QLSpa8iAvcGHun3HHljMnat1B8Y8P5ej3cnamKnOvoIU3fZoX/BXd
	 R1FA99IuINIDr8zktL0b9ZSUKso6MFpeRCIx4VvDBp8q6GfyOMEOvdORnOZuPlzSsdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937008;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jpeILw+u3U70j4F7QGCBCDFN6TFY03OzUgmKFWxdHGw=;
	b=nk7V04Lsd8vIfolH8xluDbqNCzRUcwykYvtmZOTAwyO5djBAJKQO2b/2gCTn7ilX47nm
	 FKreg6WVUMvCoBP7LlBIItq17YSZyD5lE5FEyHFNJPMFHQco9/lhL41dYNa6KSauiFi4h
	 boVoVmhUnW/XwT5mKME2CR63sGcLNA7NmlwWjPkJeT7PWghJdXqCYXSZst3dNmg9EDZ9j
	 xUKs9QZyQhJnnLxVRqIHgo0NXtSdWsa0syau/061RsDJRF7UlqkQD1ENxWKgoJ8HvgP9s
	 ke94hEDNzvyzo1sAkQ/NztwsB5IXWFyzPg9lq8pUNfrq2x+77KNtHxUN8imFsVj7INA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iodev.co.uk;
	spf=pass smtp.mailfrom=iodev.co.uk;
	arc=none smtp.remote-ip=46.30.189.100
Received: from iodev.co.uk (iodev.co.uk [46.30.189.100])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930D1606A31C;
	Tue, 17 Nov 2026 17:36:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 930D1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iodev.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iodev.co.uk
Received: from pirotess (unknown [79.116.217.174])
	by iodev.co.uk (Postfix) with ESMTPSA id BF9D05E3191;
	Tue, 17 Nov 2026 18:36:44 +0100 (CET)
Date: Tue, 17 Nov 2026 18:36:43 +0100
From: Ismael Luceno <ismael@iodev.co.uk>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, David Sterba
 <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Christian Brauner
 <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara
 <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/8] btrfs: assemble a multi-device root filesystem
 without an initrd
Message-ID: <20261117183643.36afff2b@pirotess>
In-Reply-To: <fc1f9f58-71ad-410e-bf03-8b27e607ab76@suse.com>
References: <20261116224316.11237-10-ismael@iodev.co.uk>
	<fc1f9f58-71ad-410e-bf03-8b27e607ab76@suse.com>
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

On Tue, 17 Nov 2026 10:11:46 +1030
Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2026/11/17 09:13, Ismael Luceno =E5=86=99=E9=81=93:
> > A multi-device btrfs root filesystem is normally assembled by the
> > device scanner that an initrd runs before mounting the root. =20
>=20
> What is the problem here?
>=20
> Is generating an initramfs really that complex?

Why depend on an initramfs?
