From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Filesystem acting up during balance
Date: Fri, 9 Dec 2011 10:45:36 +0700
Message-ID: <CAG1y0sff84hnLsZFZJ0h_S+W6nbTBhN2afQzJUFPQeL7rzJSLA@mail.gmail.com>
References: <CA+NZatJO2U8PhQC_xK9O0uAb9jbVTpfNwuPj-14rffbXhBfu2Q@mail.gmail.com>
	<20111208153529.GK8971@shiny>
	<CA+NZatKxzWHSh3=2KZjjygB_ja9M2WbJnb4G_eHL3zocJJ=dCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: =?ISO-8859-1?Q?Ricardo_B=E1nffy?= <rbanffy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+NZatKxzWHSh3=2KZjjygB_ja9M2WbJnb4G_eHL3zocJJ=dCg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/12/9 Ricardo B=E1nffy <rbanffy@gmail.com>:
> Dec =A09 01:06:21 adams kernel: [ =A0207.912535] usb 1-2.1: reset hig=
h
> speed USB device number 7 using ehci_hcd

That's usually a REALLY bad sign.

If you can remove the drive from the USB enclosure, I suggest you plug
it to onboard SATA port. That way at least you won't have to deal with
USB reset/retries. After that, I'd try copying the data off the disk
first (with dd_rescue). You'd need a big enough disk for this.

Only after that, I'd try again mounting the copy.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
