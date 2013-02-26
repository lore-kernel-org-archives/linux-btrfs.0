Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab3BZA0K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 19:26:10 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1Q0Q9J2020593
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 19:26:10 -0500
Date: Mon, 25 Feb 2013 16:26:09 -0800
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/17] btrfs-progs: Unify size-parsing
Message-ID: <20130226002609.GH1658@lenny.home.zabbo.net>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
 <1361832890-40921-2-git-send-email-sandeen@redhat.com>
 <20130225232651.GE1658@lenny.home.zabbo.net>
 <512BF5A1.8040404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <512BF5A1.8040404@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > These comments still annoy me :).  
> 
> it shuts up coverity & other static checkers which are worried about
> a missing break...

Yeah, I know.  And it's annoying!  So my little brain fart there was an
attempt to use a construct that simply couldn't be confused with
mistakes that'd require comments to clear up.

> If you want to submit that patch as a further cleanup I'd review it ;)

Sure!

> But TBH (going out on a limb crossing Zach here ;) my feeble brain
> is easily confused by your clever code.  I'd rather just do the
> simple thing simply...

Hrmph.  pow() is hardly rocket science :).

- z
