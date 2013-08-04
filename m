Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:40745 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab3HDPIV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Aug 2013 11:08:21 -0400
Received: from freie (home.lxoliva.fsfla.org [172.31.160.22])
	by linux-libre.fsfla.org (8.14.4/8.14.4/Debian-2ubuntu2) with ESMTP id r74Ew5BE017292
	for <linux-btrfs@vger.kernel.org>; Sun, 4 Aug 2013 14:58:05 GMT
From: Alexandre Oliva <oliva@gnu.org>
To: Jerome Haltom <wasabi@cogito.cx>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Q: Why subvolumes?
References: <CA+V+5QrNAo_RVEiONHRqkN5O89jgtoFDecuWnu41_ovJmLVhuA@mail.gmail.com>
	<20130723150620.GG20517@carfax.org.uk> <51EEC1BD.9030001@gmail.com>
	<20130723193013.GI20517@carfax.org.uk>
	<CA+V+5QriWTMdyX+M=hi=e_nZkK2oLKhXus8kmjX_KpYPBTRVrw@mail.gmail.com>
Date: Sun, 04 Aug 2013 11:56:56 -0300
In-Reply-To: <CA+V+5QriWTMdyX+M=hi=e_nZkK2oLKhXus8kmjX_KpYPBTRVrw@mail.gmail.com>
	(Jerome Haltom's message of "Tue, 23 Jul 2013 14:43:13 -0500")
Message-ID: <ory58h7bd3.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Jul 23, 2013, Jerome Haltom <wasabi@cogito.cx> wrote:

> Why not just create the new dev_id on the destination snapshot of any
> directory? That way the snapshot can share inodes with is source.

Agreed.  Nothing stops us from implementing snapshotting of any
directory whatsoever: all it takes is to take a snapshot of the
subvolume enclosing the directory we want to snapshot, removing
everything that's not in the requested directory from the snapshot, and
making that directory the root of the snapshot.  The only tricky bit
here AFAICT is to arrange for the non-snapshotted subtree components to
be cleaned up in background.  If we had some primitive to unlink an
entire subtree and clean it up in background we could use that.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
