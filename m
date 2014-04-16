Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:40192 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbaDPR6k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 13:58:40 -0400
Date: Wed, 16 Apr 2014 18:58:37 +0100
From: Richard Davies <richard@arachsys.com>
To: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org
Subject: Re: Kernel crash triggered by dd to file with memcg, worst on btrfs
Message-ID: <20140416175837.GA9412@alpha.arachsys.com>
References: <20140416174210.GA11486@alpha.arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140416174210.GA11486@alpha.arachsys.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Richard Davies wrote:
> I have a test case in which I can often crash an entire machine by running
> dd to a file with a memcg with relatively generous limits. This is
> simplified from real world problems with heavy disk i/o inside containers.
>
> The crashes are easy to trigger when dding to create a file on btrfs. On
> ext3, typically there is just an error in the kernel log, although
> occasionally it also crashes.

A further note - the ext3 SLUB errors occur when dding into a ext3 file
alone. The few ext3 crashes occurred when dding into a btrfs file for a
while without a crash, then switching to dding into an ext3 file. So the
"ext3 crashes" could actually be due to btrfs cached data still in memory -
i.e. all crashes could be due to btrfs use.

Richard.
