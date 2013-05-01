Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48105 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab3EATZI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 May 2013 15:25:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UXceF-0003mA-Q0
	for linux-btrfs@vger.kernel.org; Wed, 01 May 2013 21:25:04 +0200
Received: from 97-83-132-254.dhcp.eucl.wi.charter.com ([97.83.132.254])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 May 2013 21:25:03 +0200
Received: from jnelson by 97-83-132-254.dhcp.eucl.wi.charter.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 May 2013 21:25:03 +0200
To: linux-btrfs@vger.kernel.org
From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:921 =?utf-8?b?X19idHJmc193cml0ZV9vdXRfY2FjaGUrMHg2YjkvMHg5YTA=?= [btrfs]()
Date: Wed, 1 May 2013 19:19:54 +0000 (UTC)
Message-ID: <loom.20130501T211832-352@post.gmane.org>
References: <CADn-QaMao+mtnJVuwjbnqHgFzKhqUfn2uiDgN5hFw_fHP+mGcQ@mail.gmail.com> <CVrGRAreCXB@helmut.hullen.de> <20130430094131.GA8274@carfax.org.uk> <loom.20130430T133556-803@post.gmane.org> <20130430135816.GD2580@localhost.localdomain> <CADn-QaMFct-5XgMbqiWMG_pa-AzgOQOZLUc-CNTrAPpG7633Aw@mail.gmail.com> <20130430175351.GF2580@localhost.localdomain> <CADn-QaO_YqroR=EnrD1+tfRNRvLiLkhAMMAUxrbA_4s5-b5rxQ@mail.gmail.com> <20130501185701.GA12414@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <jbacik <at> fusionio.com> writes:

..
> Ok well that's not good, I'm not sure how you got a 156 gigabyte block 
group,
> but thats why that warning is going off.  Can you pull btrfs-image down 
from
> here
> 
> git://github.com/josefbacik/btrfs-progs.git

What is the difference between this git repo and the one at 
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

I notice that the former has commits the latter doesn't. Is the latter the 
analogue to btrfs-next ? 



