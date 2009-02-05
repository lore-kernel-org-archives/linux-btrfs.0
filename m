From: jim owens <jowens@hp.com>
Subject: Re: Warning and BUG with btrfs and corrupted image
Date: Thu, 05 Feb 2009 09:19:28 -0500
Message-ID: <498AF570.9030803@hp.com>
References: <20090120125944.GC10158@disturbed> <20090120132829.GA27429@infradead.org> <20090120222019.GB2320@elf.ucw.cz> <20090121040042.GI10158@disturbed> <20090126162711.GA2083@elf.ucw.cz> <20090201014050.GD24173@disturbed> <20090204182951.GC4797@elf.ucw.cz> <20090205085916.GP24173@disturbed> <20090205090229.GA2011@elf.ucw.cz> <1233838959.15948.6.camel@think.oraclecorp.com> <20090205135011.GA2294@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Eric Sesterhenn <snakebyte@gmx.de>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Pavel Machek <pavel@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090205135011.GA2294@elf.ucw.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Pavel Machek wrote:
>> If you don't want it, don't compile it in.  The Kconfig text is very
>> clear.
> 
> No, I'd not expect that option to panic systems. That's why I
> suggested:
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index 29228f5..b7ac847 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -77,4 +77,7 @@ config XFS_DEBUG
>  	  Note that the resulting code will be HUGE and SLOW, and probably
>  	  not useful unless you are debugging a particular problem.
>  
> +	  Turning this option on will result in kernel panicking any time
> +	  it detects on-disk corruption.
> +
>  	  Say N unless you are an XFS developer, or you play one on TV.

If you really want a better warning it should simply be:

           Choosing Y will make XFS panic on survivable events.

I understand you may have a concern that "normal users" will select
the debug option by mistake, but I don't think that is realistic.
My experience is they will not build custom debug kernels even if
you beg them to.  They will only use the distro build and a
distro should never turn this option on outside their own labs.

Any non-xfs kernel developer who turns this on and gets
snake bit will only do it once.

jim
