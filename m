From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] mark internal functions static
Date: Tue, 12 Apr 2011 08:41:40 -0400
Message-ID: <20110412124140.GA26337@dhcp231-156.rdu.redhat.com>
References: <BANLkTinUKcSNp_TN8FaE8Tiy-VX=F+v03Q@mail.gmail.com> <4DA32231.5000806@redhat.com> <BANLkTimM3dsPxp+oFJuK7JX8iSJRd=BBtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTimM3dsPxp+oFJuK7JX8iSJRd=BBtA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 12, 2011 at 09:30:42AM +0800, Daniel J Blueman wrote:
> On 11 April 2011 23:45, Josef Bacik <josef@redhat.com> wrote:
> > On 04/11/2011 11:40 AM, Daniel J Blueman wrote:
> >>
> >> Hi Chris,
> >>
> >> This didn't make it in before, so updating to 2.6.39-rc2 and resen=
ding:
> >>
> >> Prevent needless exporting of internal functions from compilation
> >> units by marking them static.
> >>
> >
> > Looks like you have line wrapping on or something, the page looks m=
angled.
> > =A0Thanks,
>=20
> The only way I can solve this in gmail webmail is by attaching the pa=
tch.
>=20
> Is this acceptable? I guess if the mailing list strips patches, I
> guess using both may be a get-out-of-jail...
>

Try using git send-email, that works out well.  Thanks,

Josef=20
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
