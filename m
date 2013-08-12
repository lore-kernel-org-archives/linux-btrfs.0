Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51394 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529Ab3HLCyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Aug 2013 22:54:45 -0400
References: <1375949833-1104-1-git-send-email-list.xfs@jan-o-sch.net> <1375949833-1104-2-git-send-email-list.xfs@jan-o-sch.net> <5203D827.3050909@sandeen.net> <20130812011539.GM12779@dastard>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130812011539.GM12779@dastard>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <BB446B35-F3DA-462E-9E2C-9E4B780BC6B9@sandeen.net>
Cc: Jan Schmidt <list.xfs@jan-o-sch.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        "sbehrens@giantdisaster.de" <sbehrens@giantdisaster.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 1/2] xfstests: add fssum tool
Date: Sun, 11 Aug 2013 21:54:41 -0500
To: Dave Chinner <david@fromorbit.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Aug 11, 2013, at 8:15 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Aug 08, 2013 at 12:40:55PM -0500, Eric Sandeen wrote:
>> On 8/8/13 3:17 AM, Jan Schmidt wrote:
>>> SUBDIRS =
>>> 
>>> LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
>>> 
>>> +OPT_LDLIBS = -lssl -lcrypto
>> 
>> Hm, new deps.  I guess it's not a huge problem, these should always
>> be available, right?
> 
> Please, let's keep crypto out of xfstests if we can. That's just
> going to add a nightmare of US export compliance garbage to any
> distro that wants to package and ship this....
> 
It's ssl that's (optionally) required for check summing I believe.  But it's optional if done properly...

-Eric

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
