Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:60741 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab3EAS5F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 May 2013 14:57:05 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 46F947C042F
	for <linux-btrfs@vger.kernel.org>; Wed,  1 May 2013 12:57:04 -0600 (MDT)
Date: Wed, 1 May 2013 14:57:01 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:921
 __btrfs_write_out_cache+0x6b9/0x9a0 [btrfs]()
Message-ID: <20130501185701.GA12414@localhost.localdomain>
References: <CADn-QaMao+mtnJVuwjbnqHgFzKhqUfn2uiDgN5hFw_fHP+mGcQ@mail.gmail.com>
 <CVrGRAreCXB@helmut.hullen.de>
 <20130430094131.GA8274@carfax.org.uk>
 <loom.20130430T133556-803@post.gmane.org>
 <20130430135816.GD2580@localhost.localdomain>
 <CADn-QaMFct-5XgMbqiWMG_pa-AzgOQOZLUc-CNTrAPpG7633Aw@mail.gmail.com>
 <20130430175351.GF2580@localhost.localdomain>
 <CADn-QaO_YqroR=EnrD1+tfRNRvLiLkhAMMAUxrbA_4s5-b5rxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CADn-QaO_YqroR=EnrD1+tfRNRvLiLkhAMMAUxrbA_4s5-b5rxQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 01, 2013 at 12:39:47AM -0600, Alexander Skwar wrote:
> Hello Josef
> 
> On Tue, Apr 30, 2013 at 7:53 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> 
> > Can you run this patch and capture the output when you get the warning?  You
> > should see some mesages before the -- [ cut here ] -- part, make sure to capture
> > those.  Thanks,
> 
> Sure.
> 
> There you go (also on http://pastebin.com/7MHmgpPU):
> 
>  num_pages is 10000, blockgroup? yes
>  block group offset=83999326208, size=167959920640

Ok well that's not good, I'm not sure how you got a 156 gigabyte block group,
but thats why that warning is going off.  Can you pull btrfs-image down from
here

git://github.com/josefbacik/btrfs-progs.git

and build that and then run

./btrfs-image -c 9 -t 4 /dev/whatever somefile.img

and upload the image somewhere so I can take a look at it.  Thanks,

Josef
