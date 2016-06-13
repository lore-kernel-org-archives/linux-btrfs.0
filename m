Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from washoe.dartmouth.edu ([129.170.30.229]:39469 "EHLO
	smtp.onerussian.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933283AbcFMDrD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 23:47:03 -0400
Received: from [66.228.68.185] (helo=localhost)
	by smtp.onerussian.com with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <yoh@onerussian.com>)
	id 1bCIq4-00069n-2B
	for linux-btrfs@vger.kernel.org; Sun, 12 Jun 2016 23:47:01 -0400
Date: Sun, 12 Jun 2016 23:46:54 -0400
From: Yaroslav Halchenko <yoh@onerussian.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <20160612151531.GA28826@hopa.kiewit.dartmouth.edu>
Reply-To: yoh@onerussian.com
References: <20160610234114.GB11174@onerussian.com>
 <CAJCQCtS1UTBx1-GELqUTbrdcxmncN3bv7X3OjGGrjvzom28m+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtS1UTBx1-GELqUTbrdcxmncN3bv7X3OjGGrjvzom28m+w@mail.gmail.com>
Subject: Re: recent complete stalls of btrfs (4.6.0-rc4+) -- any advice?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Fri, 10 Jun 2016, Chris Murphy wrote:

> > Are those issues something which was fixed since 4.6.0-rc4+ or I should
> > be on look out for them to come back?  What other information should I
> > provide if I run into them again to help you troubleshoot/fix it?

> > P.S. Please CC me the replies


> 4.6.2 is current and it's a lot easier to just use that and see if it
> still happens than for someone to track down whether it's been fixed
> since a six week old RC.

Dear Chris,

Thank you for the reply!  Now running v4.7-rc2-300-g3d0f0b6

The thing is that this issue doesn't happen right away, and it takes a
while for it to develop, and seems to be only after an intensive load.
So the version I run will always be "X weeks old" if I just keep hopping
the recent release of master, and it would be an indefinite goose
chase if left un-analyzed.  That is why I would still appreciate an
advice on what specifics to report/attempt if such crash happens next
time, or may be if someone is having an idea of what could have lead to
this crash to start with.

-- 
Yaroslav O. Halchenko, Ph.D.
http://neuro.debian.net http://www.pymvpa.org http://www.fail2ban.org
Research Scientist,            Psychological and Brain Sciences Dept.
Dartmouth College, 419 Moore Hall, Hinman Box 6207, Hanover, NH 03755
Phone: +1 (603) 646-9834                       Fax: +1 (603) 646-1419
WWW:   http://www.linkedin.com/in/yarik        
