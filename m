From: Milan Broz <mbroz@redhat.com>
Subject: Re: brtfs on top of dmcrypt with SSD. No corruption iff write cache
 off?
Date: Mon, 13 Feb 2012 00:47:54 +0100
Message-ID: <4F384FAA.5060506@redhat.com>
References: <20120130003754.GD4380@merlins.org> <20120201175624.GE16796@shiny> <20120202032345.GB31903@merlins.org> <20120202124241.GW16796@shiny> <20120202152722.GI12429@merlins.org> <20120130003754.GD4380@merlins.org> <20120201175624.GE16796@shiny> <20120202032345.GB31903@merlins.org> <20120212223242.GA31989@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	jeff@deserettechnology.com
To: Marc MERLIN <marc@merlins.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120212223242.GA31989@merlins.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/12/2012 11:32 PM, Marc MERLIN wrote:
> Actually I had one more question.
>
> I read this page:
> http://www.redhat.com/archives/dm-devel/2011-July/msg00042.html
>
> I'm not super clear if with 3.2.5 kernel, I need to pass the special
> allow_discards option for brtfs and dm-crypt to be safe together, or whether
> they now talk through an API and everything "just works" :)

If you want discards to be supported in dmcrypt, you have to enable it manually.

The most comfortable way is just use recent cryptsetup and add
--allow-discards option to luksOpen command.

It will be never enabled by default in dmcrypt for security reasons
http://asalor.blogspot.com/2011/08/trim-dm-crypt-problems.html

Milan
