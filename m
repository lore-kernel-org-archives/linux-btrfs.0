From: Eduardo Silva <eduardo.silva@oracle.com>
Subject: Re: [PATCH] Btrfs-progs new btrfs_error() macro to deprecate
 fprintf(stderr, ...)
Date: Thu, 10 Feb 2011 13:12:03 -0300
Message-ID: <1297354323.28159.23.camel@monotop>
References: <1297349695.28159.21.camel@monotop>
	 <201102101607.44204.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201102101607.44204.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2011-02-10 at 16:07 +0100, Hubert Kario wrote:
> On Thursday, February 10, 2011 15:54:55 Eduardo Silva wrote:
> > Hi,
> > 
> > This patch add a new macro called btrfs_error(...) which deprecate the
> > use of fprintf(stderr, ...)
> > 
> > regards,
> > 
> > Eduardo
> 
> Sorry, but I don't see a reason for such change. IMHO it only makes the code 
> _less_ readable.
> 
> Regards,

no troubles :)

regards, 

Ed.-

