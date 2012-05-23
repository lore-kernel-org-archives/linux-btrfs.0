Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab2EWOMw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 10:12:52 -0400
Date: Wed, 23 May 2012 10:12:31 -0400
From: Josef Bacik <josef@redhat.com>
To: Christian Brunner <christian@brunner-muc.de>
Cc: Josef Bacik <josef@redhat.com>, miaox@cn.fujitsu.com,
        Martin Mailand <martin@tuxadero.com>, Sage Weil <sage@newdream.net>,
        linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: Ceph on btrfs 3.4rc
Message-ID: <20120523141230.GA2127@localhost.localdomain>
References: <20120517194358.GA9846@dhcp231-144.rdu.redhat.com>
 <CAJafhzTQJchdd600DiEnooUH-P9ZcLvW+oEczCMNskd+Ud4BmQ@mail.gmail.com>
 <4FB56B21.7070800@tuxadero.com>
 <20120518144759.GA1892@localhost.localdomain>
 <4FB685C9.2050607@tuxadero.com>
 <20120518190105.GB1892@localhost.localdomain>
 <4FB9BDBA.2030806@cn.fujitsu.com>
 <CAJafhzSmLC9yUwrxsJEz5vKYnfP0DSWdMnA0oXmLT_4CQFc1oQ@mail.gmail.com>
 <20120522173344.GB1890@localhost.localdomain>
 <CAJafhzQGHsSA6dUwOqTJERj7SgVmKFuVDHk5R+i7n0FuhUAj_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAJafhzQGHsSA6dUwOqTJERj7SgVmKFuVDHk5R+i7n0FuhUAj_g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 23, 2012 at 02:34:43PM +0200, Christian Brunner wrote:
> 2012/5/22 Josef Bacik <josef@redhat.com>:
> >>
> >
> > Yeah you would also need to change orphan_meta_reserved.  I fixed this by just
> > taking the BTRFS_I(inode)->lock when messing with these since we don't want to
> > take up all that space in the inode just for a marker.  I ran this patch for 3
> > hours with no issues, let me know if it works for you.  Thanks,
> 
> Compared to the last runs, I had to run it much longer, but somehow I
> managed to hit a BUG_ON again:
> 

Yeah it's because we access other parts of that bitfield with no lock at all
which is what is likely screwing us.  I'm going to have to redo that part and
then do the orphan fix, I'll have a patch shortly.  Thanks,

Josef
