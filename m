From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH] Btrfs-progs use safe string manipulation functions
Date: Mon, 07 Feb 2011 19:17:11 +0100
Message-ID: <4D503727.3030104@libero.it>
References: <1297081322.4615.10.camel@monotop>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Eduardo Silva <eduardo.silva@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297081322.4615.10.camel@monotop>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/07/2011 01:22 PM, Eduardo Silva wrote:
> Please find the attached patch which replace unsafe strcpy(3) by
> strncpy(3) functions.
> 
> regards, 
> 
> Eduardo Silva


Hi Eduardo,

even though some "strncpy" are unneeded because a check is performed
before, I fully agree that "strncpy" is better than a simple strcpy.
However I have to highlight that truncating a path without noticing may
be lead to a problem (think a delete operation applied to a shorter
path...).
So can I ask you to add some checks to your patch, in order to warn the
user that the path is too long ?

Regards
G.Baroncelli
