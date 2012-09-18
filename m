Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:25794 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab2IRF0O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 01:26:14 -0400
Message-ID: <5058068C.4040704@oracle.com>
Date: Tue, 18 Sep 2012 13:28:44 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Casper Bang <casper.bang@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Experiences: Why BTRFS had to yield for ZFS
References: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com>
In-Reply-To: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> A script on the test server, would then apply Oracle archive files
> from the production environment to this Oracle sync database, every
> 10'th minute, effectively making it near up-to-date with production.

> The most reliable way to do this was with a simple NFS mount (rather
> than rsync or samba). The idea then was, that it would be very fast
> and easy to make a new snapshot of the sync database, start it up, and
> voila you'd have a new instance ready to play with. A desktop machine


  archive-log-apply script - if you could, can you share the
  script itself ? or provide more details about the script.
  (It will help to understand the work-load in question).

Thanks, Anand
