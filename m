From: Josef Bacik <josef@redhat.com>
Subject: Re: BTRFS Benchmarking
Date: Mon, 7 May 2012 15:06:02 -0400
Message-ID: <20120507190601.GA3243@localhost.localdomain>
References: <CAPPqfY0iGPjRDC0YG814uiv4+9jLU54w6D5Yh=okTqG7VtwXOA@mail.gmail.com>
 <20120504160749.GA1915@localhost.localdomain>
 <CAPPqfY2zXkd0Qgd-UX5uaaWOF9vaeEs5yqo04SD9hjwmfGUq5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Olivier Doucet <webmaster@ajeux.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPPqfY2zXkd0Qgd-UX5uaaWOF9vaeEs5yqo04SD9hjwmfGUq5Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 07, 2012 at 08:42:45PM +0200, Olivier Doucet wrote:
> > Not what I've been seeing at all, but we've been working a lot in t=
his area
> > recently. =A0Please retest with btrfs-next. =A0Thanks,
>=20
> Hi,
>=20
> I tested again with kernel 3.3.4 ; I wondered if latest btrfs code is
> present in this release or not.
>=20
> Results are very similar with 3.3.4 compared to 3.3.0
>=20

It's not, you need to clone the btrfs-next tree and test with that.

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
