From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: Default to read-only on snapshot creation and have a flag if
 snapshot should be writable (was: [PATCH 0/5] btrfs: Readonly snapshots)
Date: Mon, 29 Nov 2010 13:43:22 -0800
Message-ID: <AANLkTikK0OEJneHWqABnOA+c9e1-QirctS34mV0bOFCv@mail.gmail.com>
References: <AANLkTikbmUQA7JtkjV4177jmj9WDVe1V3NvbX3ts6TNd@mail.gmail.com>
	<4CF40FE4.2030801@prnet.org>
	<AANLkTimfSTq4h0eq_hjY6aEdXgM7Gq382m1FMAXy-z=P@mail.gmail.com>
	<AANLkTi=VP4jStt41sYAD=6g8FwRfGrhqZB2pGcZjNbiN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Arendt <admin@prnet.org>, linux-btrfs@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=VP4jStt41sYAD=6g8FwRfGrhqZB2pGcZjNbiN@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 29, 2010 at 1:31 PM, Andrey Kuzmin
<andrey.v.kuzmin@gmail.com> wrote:
> This may sound excessive as any new concept introduction that late in
> development, but readonly/writable snapshots could be further
> differentiated by naming the latter clones. This way end-user would
> naturally perceive snapsot as read-only PIT fs image, while clone
> would naturally refer to (writable) head fork.
>

I'm not sure we want to take all of the terminology that zfs uses as
it may also bring the percieved drawbacks as well.  Isn't there some
additional overhead for a zfs clone compared to a snapshot?  I'm not
very familiar with zfs so that's why I ask.
