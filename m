From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: patch intoducing IOctl #21 allowing for waiting for completion of
 deleted subvol recovery
Date: Wed, 6 Oct 2010 14:41:27 -0400
Message-ID: <AANLkTi=KWGCLpZekmTd9014nzRrsR0TncUyjQNiHQD6c@mail.gmail.com>
References: <AANLkTim2eGMuc=_v9046G-C21OWq8oKDhc2rL8LAvx+_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: David Nicol <davidnicol@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim2eGMuc=_v9046G-C21OWq8oKDhc2rL8LAvx+_@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Oct 6, 2010 at 11:05 AM, David Nicol <davidnicol@gmail.com> wrote:
> The patches for btrfsctl and btrfs programs will be coming soon; I'm
> adding support for ISO8061 duration strings instead of (or in addition
> to) milliseconds and thinking about switching the order of the two
> args to btrfsctl -C from (path(default=.), ms(default=0)) to timeout
> then path, to keep it consistent with the other btrfsctl commands.
> Currently -C is special-cased in the bottom half of my btrfsctl.c
> because the path isn't the last argument.
>
> Btrfsctl apparently allows several operations to be presented as one
> set of command line arguments, sort of like find(1) does; would
> someone who does that a lot please respond off-list to discuss the
> ideal semantics of new commands?
>

The first thing I notice is that you use btrfsctl, you should base
this work on the new 'btrfs' command, which is consistant in how the
command are structured.
You could use: btrfs filesystem sync -d <path>  for example, it would
be like a normal sync but waits for pending '-d'eletion.
