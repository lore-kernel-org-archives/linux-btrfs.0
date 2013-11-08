Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from milliways.cryptomilk.org ([78.46.80.163]:40119 "EHLO
	milliways.cryptomilk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab3KHOLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2013 09:11:45 -0500
Received: from localhost (localhost [127.0.0.1])
	by milliways.cryptomilk.org (Postfix) with SMTP id C23A4E0D28
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Nov 2013 15:11:43 +0100 (CET)
From: Andreas Schneider <asn@cryptomilk.org>
To: cwillu <cwillu@cwillu.com>
Cc: linux-btrfs@vger.kernel.org, samba-technical@lists.samba.org
Subject: Re: btrfs and default directory link count
Date: Fri, 08 Nov 2013 15:11:41 +0100
Message-ID: <13844973.BJjIDpTNz7@magrathea>
In-Reply-To: <CAE5mzvgtAryNUTkSQY0_cLyVPOHzig5Jw9ghL_Kd-b-vPbAxTw@mail.gmail.com>
References: <1528226.ndb0o2H7AC@magrathea> <CAE5mzvgtAryNUTkSQY0_cLyVPOHzig5Jw9ghL_Kd-b-vPbAxTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 08 November 2013 06:24:01 cwillu wrote:
> On Fri, Nov 8, 2013 at 5:07 AM, Andreas Schneider <asn@cryptomilk.org> 
wrote:
> > Hello,
> > 
> > I did run the Samba testsuite and have a failing test
> > (samba.vfstest.stream_depot). It revealed that it only fails on btrfs. The
> > reason is that a simple check fails:
> > 
> > if (smb_fname_base->st.st_ex_nlink == 2)
> > 
> > If you create a directory on btrfs and check stat:
> > 
> > $ mkdir x
> > $ stat x
> > 
> >   File: ‘x’
> >   Size: 0               Blocks: 0          IO Block: 4096   directory
> > 
> > Device: 2bh/43d Inode: 3834720     Links: 1
> > Access: (0755/drwxr-xr-x)  Uid: ( 1000/     asn)   Gid: (  100/   users)
> > Access: 2013-11-08 11:54:32.431040963 +0100
> > Modify: 2013-11-08 11:54:32.430040956 +0100
> > Change: 2013-11-08 11:54:32.430040956 +0100
> > 
> >  Birth: -
> > 
> > then you see Links: 1. On ext4 or other filesystems:
> > 
> > mkdir x
> > stat x
> > 
> >   File: ‘x’
> >   Size: 4096            Blocks: 8          IO Block: 4096   directory
> > 
> > Device: fd00h/64768d    Inode: 8126886     Links: 2
> > Access: (0755/drwxr-xr-x)  Uid: ( 1000/     asn)   Gid: (  100/   users)
> > Access: 2013-11-08 11:54:55.428212340 +0100
> > Modify: 2013-11-08 11:54:55.427212319 +0100
> > Change: 2013-11-08 11:54:55.427212319 +0100
> > 
> >  Birth: -
> > 
> > the link count for a directory differs: Links: 2.
> > 
> > Why is btrfs different here? Could someone explain this?
> 
> As I understand it, inferring the number of directory entries from
> st_nlink is an optimization that isn't universally valid. If that
> count is 1, it must be considered invalid, and programs that don't
> handle this correctly are broken.  Coreutils handle this, at least...

Thanks for the explanation, I will fix our code.


	-- andreas

-- 
Andreas Schneider                   GPG-ID: CC014E3D
www.cryptomilk.org                asn@cryptomilk.org

