From: Eduardo Silva <eduardo.silva@oracle.com>
Subject: Re: [PATCH] Btrfs-progs use safe string manipulation functions
Date: Thu, 10 Feb 2011 08:49:28 -0300
Message-ID: <1297338568.28159.8.camel@monotop>
References: <1297081322.4615.10.camel@monotop> <4D53C711.3000309@nsc.liu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: Thomas Bellman <bellman@nsc.liu.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D53C711.3000309@nsc.liu.se>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2011-02-10 at 12:08 +0100, Thomas Bellman wrote:
> On 2011-02-07 13:22, Eduardo Silva wrote:
> 
> > Please find the attached patch which replace unsafe strcpy(3) by
> > strncpy(3) functions.
> 
> strncpy() doesn't NUL-terminate the destination buffer if the
> maximum length is reached.  And as far as I can see, there is
> no other initialization of those buffers to zeroes, except for
> super.label in make_btrfs() in utils.c.
> 
> So please change those strncpy() calls to something like:
> 
>     strncpy(args.name, source, BTRFS_PATH_NAME_MAX);
>     args.name[BTRFS_PATH_NAME_MAX] = '\0';
> 

Seems like a string manipulation function is the way to go, will send a
new patch shortly, 

best, 

Eduardo

