Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:44735 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756077Ab3BZHFb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 02:05:31 -0500
Date: Tue, 26 Feb 2013 18:05:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: Eric Sandeen <sandeen@redhat.com>, chris.mason@fusionio.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH, RFC] btrfs-progs: require mkfs -f force option to
 overwrite filesystem or partition table
Message-ID: <20130226070525.GP5551@dastard>
References: <511D2D2B.8040804@redhat.com>
 <5124EDAB.5020003@giantdisaster.de>
 <512BF648.1090602@jp.fujitsu.com>
 <512BFCD1.3030709@redhat.com>
 <512C3230.8020305@jp.fujitsu.com>
 <512C34CC.3070904@redhat.com>
 <512C3927.2080708@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <512C3927.2080708@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 01:25:11PM +0900, Tsutomu Itoh wrote:
> On 2013/02/26 13:06, Eric Sandeen wrote:
> >On 2/25/13 9:55 PM, Tsutomu Itoh wrote:
> >>EXPERIMENTAL... It's certainly so.
> >>However, I think that we should not add the option that it troubles
> >>a lot of people.
> >
> >Well, I sent it as an RFC.  Chris merged it; I'll defer to his judgement.
> 
> Agreed. So, I sent revert request to Chris :)

Where? I want to NACK the revert - this is not a matter to joke
about.

You're all smart enough to know how to use shell aliases and script
variables, so this "need to type -f all the time" argument holds
absolutely no weight at all. Further, most of the time you're
working on systems that don't hold any data you care about and so
the consequences of a mistake are very minor.

However, users often make mistakes and we have to take that into
account when deciding on the default behaviour of our tools.
Tools that destroy data *must* err on the side of conservative
default behaviour simply because of the fact that destroying the
wrong data can have catastrophic consequences. It's not your data
that is being destroyed, but it is data that you have a
*responsibility to safeguard* as a filesystem developer.

Think about it this way: how happy would an important customer be if
they decided that *you* were directly responsible for a major data
loss incident because they found it would have been prevented by the
"-f" patch? I don't think that the explanation of "it was
inconvenient to me" would be an acceptable answer.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
