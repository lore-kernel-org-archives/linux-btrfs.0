Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57729 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422920Ab3CVUbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 16:31:45 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 8D3577C0643
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 14:31:44 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>, Alexandre Oliva <oliva@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130322180705.27874.96638@localhost.localdomain>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
References: <orhak8fm0u.fsf@livre.home>
 <20130322180705.27874.96638@localhost.localdomain>
Message-ID: <20130322203142.27874.84834@localhost.localdomain>
Subject: Re: corruption of active mmapped files in btrfs snapshots
Date: Fri, 22 Mar 2013 16:31:42 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Chris Mason (2013-03-22 14:07:05)
> [ mmap corruptions with leveldb and btrfs compression ]
> 
> I ran this a number of times with compression off and wasn't able to
> trigger problems.  With compress=lzo, I see errors on every run.
> 
> Compile: gcc -Wall -o mmap-trunc mmap-trunc.c
> Run: ./mmap-trunc file_name
> 
> The basic idea is to create a 256MB file in steps.  Each step ftruncates
> the file larger, and then mmaps a region for writing.  It dirties some
> unaligned bytes (a little more than 8K), and then munmaps.
> 
> Then a verify stage goes back through the file to make sure the data we
> wrote is really there.  I'm using a simple rotating pattern of chars
> that compress very well.

Going through the code here, when I change the test to truncate once in
the very beginning, I still get errors.  So, it isn't an interaction
between mmap and truncate.  It must be a problem between lzo and mmap.

-chris
