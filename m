From: Thomas Bellman <bellman@nsc.liu.se>
Subject: Re: [PATCH] Btrfs-progs use safe string manipulation functions
Date: Thu, 10 Feb 2011 12:08:01 +0100
Message-ID: <4D53C711.3000309@nsc.liu.se>
References: <1297081322.4615.10.camel@monotop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Eduardo Silva <eduardo.silva@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297081322.4615.10.camel@monotop>
List-ID: <linux-btrfs.vger.kernel.org>

On 2011-02-07 13:22, Eduardo Silva wrote:

> Please find the attached patch which replace unsafe strcpy(3) by
> strncpy(3) functions.

strncpy() doesn't NUL-terminate the destination buffer if the
maximum length is reached.  And as far as I can see, there is
no other initialization of those buffers to zeroes, except for
super.label in make_btrfs() in utils.c.

So please change those strncpy() calls to something like:

    strncpy(args.name, source, BTRFS_PATH_NAME_MAX);
    args.name[BTRFS_PATH_NAME_MAX] = '\0';

(Note that the name member of struct btrfs_ioctl_vol_args is
BTRFS_PATH_NAME_MAX + 1 long, so the above is correct for that
field.)

And of course similarly in those cases where you copy to something
other than a struct btrfs_ioctl_vol_args.


There were also a two places where you used spaces instead of tabs
for indentation (in main() in btrfsctl.c, and the declaration of
pretty_len in pretty_sizes() in utils.c).


	/Bellman
