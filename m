From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: Will BTRFS repair or restore data if corrupted?
Date: Thu, 26 Jan 2012 10:33:03 +0100
Message-ID: <4F211DCF.90707@giantdisaster.de>
References: <4F208FFD.4020508@online.no> <20120126085938.GC5531@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, Waxhead <waxhead@online.no>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120126085938.GC5531@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 1/26/2012 9:59 AM, Hugo Mills wrote:
> On Thu, Jan 26, 2012 at 12:27:57AM +0100, Waxhead wrote:
[...]
>> Will BTRFS try to repair the corrupt data or will it simply silently
>> restore the data without the user knowing that a file has been
>> "fixed"?
> 
>    No, it'll just return the good copy and report the failure in the
> system logs. If you want to fix the corrupt data, you need to use
> scrub, which will check everything and fix blocks with failed
> checksums.

Since 3.2, btrfs rewrites the corrupt disk block (commit 4a54c8c and
f4a8e65 from Jan Schmidt), even without scrub.
