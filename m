Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:56907 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab3CST1T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 15:27:19 -0400
From: Alexandre Oliva <oliva@gnu.org>
To: Sage Weil <sage@inktank.com>
Cc: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs\@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ceph-devel\@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: corruption of active mmapped files in btrfs snapshots
References: <orhak8fm0u.fsf@livre.home>
	<20130318225245.25964.22219@localhost.localdomain>
	<orzjy0dkz9.fsf@livre.home>
	<20130319120940.29898.80124@localhost.localdomain>
	<alpine.DEB.2.00.1303191027320.4850@cobra.newdream.net>
Date: Tue, 19 Mar 2013 16:26:56 -0300
In-Reply-To: <alpine.DEB.2.00.1303191027320.4850@cobra.newdream.net> (Sage
	Weil's message of "Tue, 19 Mar 2013 10:29:11 -0700 (PDT)")
Message-ID: <or620ndwcf.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mar 19, 2013, Sage Weil <sage@inktank.com> wrote:

> There is a set of unit tests in the leveldb source tree that ought to do 
> the trick:

> 	git clone https://code.google.com/p/leveldb/

But these don't create btrfs snapshots.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
