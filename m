From: Miguel Garrido <miguel@mjgar.com>
Subject: Re: Cannot Deinstall a Debian Package
Date: Thu, 5 May 2011 19:06:19 -0400
Message-ID: <BANLkTikve7YaHWjqOmHUvVd3psqYs022EA@mail.gmail.com>
References: <201105031227.43619.CACook@quantum-sci.com>
	<201105051440.07434.CACook@quantum-sci.com>
	<BANLkTi=qRCM3Rt5oBkCfxi4af2GYeHWJGg@mail.gmail.com>
	<201105051533.07880.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105051533.07880.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 5, 2011 at 6:33 PM, <CACook@quantum-sci.com> wrote:
>
> On Thursday 5 May, 2011 14:48:49 cwillu wrote:
> > How old was the filesystem? =A0It might just have been lingering
> > problems from an older kernel, which would be cleared up entirely b=
y
> > the balance you just ran.
>
> I specifically set up the filesystem with the Live CD of the M- relea=
se of Ubuntu, so as to be using a much newer kernel than Debian's. =A0T=
his was in December. =A0Then I used the Debian net install CD in Expert=
 mode to install the OS.
>
> I took all pains to be using the newest OS available to set up the di=
sks, so as to take advantage of WD's Advanced Format, and the newest im=
provements to BTRFS. =A0But the balance is still going after more than =
an hour.
>
> I am seeing drastically conflicting info from df and btrfs filesystem=
 df, which is inexplicable.
>

https://btrfs.wiki.kernel.org/index.php/FAQ#Why_does_df_show_incorrect_=
free_space_for_my_RAID_volume.3F

The above link may help explain why df and btrfs fi df differ.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
