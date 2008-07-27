From: "Ahmed Kamal" <email.ahmedkamal@googlemail.com>
Subject: Re: Fix: btrfsctl arguments handling
Date: Sun, 27 Jul 2008 22:02:45 +0300
Message-ID: <3da3b5b40807271202r43b887e9gfadad07ab2c3233e@mail.gmail.com>
References: <3da3b5b40807180937md87cb4aj965b1b3a52ae7358@mail.gmail.com>
	 <3da3b5b40807180944p21b476f7sd00c97afb1cb9dfc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40807180944p21b476f7sd00c97afb1cb9dfc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Is this not a valid patch/fix ? Who do I have to bug to get this merged :)

On Fri, Jul 18, 2008 at 7:44 PM, Ahmed Kamal
<email.ahmedkamal@googlemail.com> wrote:
>
> That's probably a more proper patch
>
> # HG changeset patch
> # Signed-Off-By: Ahmed Kamal <email.ahmedkamal@googlemail.com>
> # Date 1216410189 -10800
> # Node ID f35e2b3b25a97d42452ec90b6c524721d9c9941f
> # Parent  1aa4b32e3efd452531cb0b883edfcc3761487fca
> Fixing btrfsctl argument handling
>
> diff -r 1aa4b32e3efd -r f35e2b3b25a9 btrfsctl.c
> --- a/btrfsctl.c        Tue Jun 10 10:09:18 2008 -0400
> +++ b/btrfsctl.c        Fri Jul 18 22:43:09 2008 +0300
> @@ -73,7 +73,7 @@
>                btrfs_scan_one_dir("/dev", 1);
>                exit(0);
>        }
> -       for (i = 1; i < ac - 1; i++) {
> +       for (i = 1; i <= ac - 1; i++) {
>                if (strcmp(av[i], "-s") == 0) {
>                        if (i + 1 >= ac - 1) {
>                                fprintf(stderr, "-s requires an arg");
>
>
> On Fri, Jul 18, 2008 at 7:37 PM, Ahmed Kamal
> <email.ahmedkamal@googlemail.com> wrote:
> > Hi,
> >
> > btrfsctl -A
> > in the current -unstable branch, does not result in the error message
> > designated for it, namely "-A requires an arg\n". Turns out the whole
> > loop was being skipped!
> > Please find a patch attached that fixed it for me.
> >
> > diff -r 1aa4b32e3efd btrfsctl.c
> > --- a/btrfsctl.c        Tue Jun 10 10:09:18 2008 -0400
> > +++ b/btrfsctl.c        Fri Jul 18 22:34:46 2008 +0300
> > @@ -73,7 +73,7 @@
> >                btrfs_scan_one_dir("/dev", 1);
> >                exit(0);
> >        }
> > -       for (i = 1; i < ac - 1; i++) {
> > +       for (i = 1; i <= ac - 1; i++) {
> >                if (strcmp(av[i], "-s") == 0) {
> >                        if (i + 1 >= ac - 1) {
> >                                fprintf(stderr, "-s requires an arg");
> >
> >
> > PS: Is this the correct way to submit patches ?
> >
