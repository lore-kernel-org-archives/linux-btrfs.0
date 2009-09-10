From: =?ISO-8859-1?Q?Bryan_=D8stergaard?= <bryan.ostergaard@gmail.com>
Subject: Re: btrfs csum failed on git .pack file
Date: Thu, 10 Sep 2009 12:49:58 +0200
Message-ID: <73967b650909100349o377174c0kc84a8d3ea2cc3001@mail.gmail.com>
References: <20090907203531.GA1889@phenom2.trippelsdorf.de>
	 <20090908200041.GF18599@kernel.dk>
	 <20090908202211.GA1901@phenom2.trippelsdorf.de>
	 <20090908203214.GH18599@kernel.dk>
	 <20090909065533.GA2861@phenom2.trippelsdorf.de>
	 <20090909070141.GL18599@kernel.dk>
	 <21A769F737B64494B43804084FB1EF88@home.omattos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	linux-btrfs@vger.kernel.org
To: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <21A769F737B64494B43804084FB1EF88@home.omattos.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 9, 2009 at 11:01 PM, Oliver Mattos
<oliver.mattos08@imperial.ac.uk> wrote:
>
>>> What a strange coincidence that it affected git pack files in both =
cases.
>>> It's almost too improbable...
>
I had similar problems with a broken git repository about two weeks
ago. This was on a regular laptop harddrive that's never reported any
errors.

Unfortunately I rm'ed the repository and cloned it again so I can't
check exactly what caused the corruption. Interestingly I've just
discovered a broken tar.bz2 file that shows similar symptoms as what's
been described here earlier.

The first (and by far largest) chunk of the file consists entirely of
0x01 bytes followed by a smaller chunk that appears to be a PNG file
and then arch/sparc/include/asm/fhc.h from the linux kernel. After
this I have a small chunk of 0x00 bytes followed by
arch/sparc/include/asm/floppy.h.

This pattern is repeated several times with different include files
from the kernel sources and the file ends with a small chunk of 0x01
bytes again.

The harddisk in question is:
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Fujitsu MHV series
Device Model:     FUJITSU MHV2080BH
Serial Number:    NW05T6425FRY
=46irmware Version: 00840028
User Capacity:    80,025,280,000 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 4a
Local Time is:    Thu Sep 10 12:40:10 2009 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

As already mentioned it's never reported any errors and I also haven't
seen any problems like this before when using ext3 or ext4. The broken
file is available at http://omploader.org/vMmJtbg if that's any help.

Regards,
Bryan =D8stergaard
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
