From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: [PATCH 5/5][REPOST][BTRFS-PROGS] Add the "btrfs filesystem label" command
Date: Sun, 5 Dec 2010 19:48:24 -0500
Message-ID: <-2756013869289248669@unknownmsgid>
References: <201012051846.51124.kreijack@inwind.it>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Type: text/plain; charset=ISO-8859-1
Cc: "chris.mason@oracle.com" <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Felix Blanke <felixblanke@gmail.com>
To: "kreijack@inwind.it" <kreijack@inwind.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201012051846.51124.kreijack@inwind.it>
List-ID: <linux-btrfs.vger.kernel.org>

On 2010-12-05, at 12:47, Goffredo Baroncelli <kreijack@inwind.it> wrote:

> Hi all,
>
> this patch adds the command "btrfs filesystem label" to change (or show) the
> label of a filesystem.
> This patch is a subset of the one written previously by Morey Roof. I
> included the user space part only. So it is possible only to change/show a

label of a *single device* and *umounted* filesystem.


Personally I really don't understand why changing the label of a
mounted filesystem would cause any problem at all. Could someone
explain that to me?

Or at least the applet could include some force option for filesystem
that can't be umounted, for example, root.

Jerome
