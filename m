Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:55891 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757296Ab2JEUoK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Oct 2012 16:44:10 -0400
Date: Fri, 5 Oct 2012 16:44:07 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Out of memory condition
Message-ID: <20121005204407.GA12424@localhost.localdomain>
References: <CALJXSJrtf7wid5xS4H5+E6ws_SjcgjB48ppoU_9+24JSkggKUw@mail.gmail.com>
 <CALJXSJoKW=7ev8obh3d_XYux0JjwJ+bVAwj_ps7Eih9eYxOQ3w@mail.gmail.com>
 <20121003205247.GO2370@localhost.localdomain>
 <CALJXSJrbe62q6XCOf5xB6ra1kwSOnVyL6DvYqS7ncyUQndfkgw@mail.gmail.com>
 <20121005174316.GQ2370@localhost.localdomain>
 <CALJXSJpxgjy6cEGhpnKQby0b_GE0XgajN9B5PSrLm7kZv7jtZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CALJXSJpxgjy6cEGhpnKQby0b_GE0XgajN9B5PSrLm7kZv7jtZw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 05, 2012 at 02:23:25PM -0600, Jérôme Poulin wrote:
> I guess I'll be the guy who will test out of memory conditions! Here's
> another stack further down the code.
> 

Ok that was just a warning, did the box keep going after that?  I've fixed it up
and sent a patch, unapply all the patches I've given you and apply the new ones
I've just sent (there are 3) and see how that works for you.  If you don't get
any BUG()'s but it's still hung then I'll need sysrq+w to see where you are
hung, we probably screw up unlocking in these codepaths somewhere.  Thanks,

Josef
