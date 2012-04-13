From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Fri, 13 Apr 2012 15:20:56 +0200
Message-ID: <CAFDW0jKS6VXtosBuppoWLzJpe=pTQ-=RCd7SsdqL33eRw4AUMQ@mail.gmail.com>
References: <1333986823.2928.6.camel@ayu>
	<1333991404.2817.6.camel@ayu>
	<20120409205429.GB6958@localhost.localdomain>
	<1334006446.2678.0.camel@ayu>
	<20120410151645.GC2296@localhost.localdomain>
	<CAFDW0j+=qe49pX3frjEoozOMz-gKKxqJ+jeeTgyXEskDL_9W8w@mail.gmail.com>
	<20120411170422.GA2506@localhost.localdomain>
	<CAFDW0jJZ16jPn766fdn3Hm=WWkR71n0kJapfPZzgHd3o71b1hQ@mail.gmail.com>
	<20120412133747.GE1924@localhost.localdomain>
	<20120412142349.GI1924@localhost.localdomain>
	<CAFDW0jJq46TXa_a1soYESgjZosBDM8razvT271S3_SoyQeBbSA@mail.gmail.com>
	<CAE5mzvjJ+fuixm=OpKua6t6s6sncz1RGwXem8D6ZS=jDRDQ3+g@mail.gmail.com>
	<CAFDW0jL4TTWtqMw4f_1WpQuEU7Q1SoTUo_rBVGcdHt008Sx1Zw@mail.gmail.com>
	<CAFDW0jKMEQ+oMN41euh1cMy4h+6Qntt5UL9+0HZw4r9SpDJVvQ@mail.gmail.com>
	<CAE5mzvhk+bC2N5+JEw-N-KBNmvLO-Y8x5gCPik2cokE7MX8Q+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	Calvin Walton <calvin.walton@kepstin.ca>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvhk+bC2N5+JEw-N-KBNmvLO-Y8x5gCPik2cokE7MX8Q+w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 13, 2012 at 2:57 PM, cwillu <cwillu@cwillu.com> wrote:
> These are usb disks? =C2=A0Does that failure at 12.241517 (or related=
)
> happen every time?

no, 0CCD:0052 is the webcam. i dont have the modules for the webcam
in initramfs, thats why.

the real slowness is around 33.305370

The 2 SATA Disks are fine. I have many more Computers with varying
Hardware but the same Kernel and see the same Problems there too.

Ahmet
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
