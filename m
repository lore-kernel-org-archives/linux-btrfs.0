Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53899 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaHLOYc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 10:24:32 -0400
Date: Tue, 12 Aug 2014 07:24:23 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140812142423.GJ8314@merlins.org>
References: <CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
 <CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
 <pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
 <CAETJ_S8347mtU6-o9BW=_Q27atdcj6P-aFZ1551S6G6rXBS8=A@mail.gmail.com>
 <CAETJ_S9HsWEYrV2zrfr8ZSD69SoFCiHnND38HLo8pq7ENiEPbw@mail.gmail.com>
 <CAETJ_S8DT=yW6V8bmAJ5s-+ZbuLjnDUK_XWEFRwK_p8hoR+LWA@mail.gmail.com>
 <pan$d6d2e$b19333f0$ee4ea84e$5a707866@cox.net>
 <A7CFCD27-F663-425A-A695-3E7842777348@colorremedies.com>
 <CAETJ_S_YDnJsf9Fc6+ynpBVK7MXv3RGuhhJrSVV2Tizf1J+kdA@mail.gmail.com>
 <pan$8f34b$65843f03$7e0dd88e$286fcd58@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$8f34b$65843f03$7e0dd88e$286fcd58@cox.net>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 12, 2014 at 04:15:26AM +0000, Duncan wrote:
> Jose Ildefonso Camargo Tolosa posted on Mon, 11 Aug 2014 16:33:36 -0500 as
> excerpted:
> 
> > As I hate when a thread is left "hanging", you deserve to know what
> > happened in the end, you likely already guessed, but anyway: I nuked the
> > filesystem, and started over.
> > 
> > After some internal discussion in the company, we decided to move to ZFS
> > for now.  However, we will keep an eye on btrfs, and will likely deploy
> > it to some smaller system for further testing.
> > 
> > Thanks you all for your help!
> 
> Thank you too. =:^)
> 
> Sounds like a sane decision for the time being.

Just remember that ZFS is fine for internal use, but that you can never
ever ship any product based on ZFS due to its licensing.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
