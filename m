From: Jim Meyering <jim@meyering.net>
Subject: Re: BTRFS file clone support for cp
Date: Thu, 30 Jul 2009 18:48:44 +0200
Message-ID: <87ab2mqfpv.fsf@meyering.net>
References: <87d47o3fip.fsf@master.homenet> <4A6CEA48.5050208@draigBrady.com>
	<8763defuvq.fsf@meyering.net> <87ws5tvrq8.fsf@master.homenet>
	<4A6E3ADE.6050008@draigBrady.com> <8763dcvagk.fsf@master.homenet>
	<20090729130106.GF13940@think> <4A705959.7010303@draigBrady.com>
	<20090729161014.GJ13940@think> <4A70918D.6020003@draigBrady.com>
	<20090730005702.GA32157@mail.oracle.com> <87fxcevcuy.fsf@meyering.net>
	<4A715C61.1080607@draigBrady.com> <4A71CA20.2070906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?Q?P=C3=A1draig?= Brady <P@draigBrady.com>,
	Chris Mason <chris.mason@oracle.com>,
	Giuseppe Scrivano <gscrivano@gnu.org>, bug-coreutils@gnu.org,
	linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A71CA20.2070906@redhat.com> (Ric Wheeler's message of "Thu, 30
	Jul 2009 12:28:16 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

Ric Wheeler wrote:
> I think that doing reflink by default would be a horrible idea - one
> good reason to copy a file is to increase your level of fault
> tolerance and reflink magically avoids that :-)

Good point.
This would constitute another user-visible semantic change in cp:
a disk fault that affects any non-metadata block of a ref-linked file
affects both copies.

GNU cp will soon attempt this only when a --reflink option is specified.
