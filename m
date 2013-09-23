Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab3IWRfd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 13:35:33 -0400
Date: Mon, 23 Sep 2013 19:35:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Frank Holton <fholton@gmail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [RFC v2] btrfs-progs: Add recursive defrag using -r option
Message-ID: <20130923173531.GS6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAC4gV=40wHT3UcSbHsgei8zqcRwCT7-X0g7Vxzp7A_1nyNkOYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAC4gV=40wHT3UcSbHsgei8zqcRwCT7-X0g7Vxzp7A_1nyNkOYw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 17, 2013 at 11:30:52AM -0400, Frank Holton wrote:
> Thanks for that hint to use ftw. I've updated the code to use it and
> tried to make sure
> that I caught all of the styling errors.

Dunno what caused that, but the whitespace is completely messed up and
squasthed into a single space everywhere.

> Since the ftw callback doesn't take any additional options I had to add several
> global variables to pass the fancy_ioctl and range parameters. Should
> I replace all
> of the uses of those variables with the globals or just copy into the
> globals like I did in
> the code below.

Eww a callback without user data, that's kind of underdesigned. I don't
see a better workaround than the gobals.

> It does not attempt to defrag directories anymore in the recursive
> mode, however, the
> non recursive mode will still attempt to defrag directories. I figured
> since that only works
> when you run as root that it is acceptable for now.

Agreed.

> +static int global_fancy_ioctl;
> +static struct btrfs_ioctl_defrag_range_args global_range;
> +static int global_verbose;
> +static int global_errors;

For now, please prefix all of them as defrag_ so they do not get reused
like generic variables.

> @@ -349,7 +403,8 @@ static int cmd_defrag(int argc, char **argv)
>   u64 len = (u64)-1;
>   u32 thresh = 0;
>   int i;
> - int errors = 0;
> + int recursive = 0;
> + global_errors = 0;

move this out of the declaration block

>   int ret = 0;
>   int verbose = 0;
>   int fancy_ioctl = 0;

The rest looks ok, but I'll take another look when you send the next
version where the indentatino is fixed.

thanks
