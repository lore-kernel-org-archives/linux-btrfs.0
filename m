Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33704 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758266Ab3E3Szm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 May 2013 14:55:42 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2D6B39A067C
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 12:55:42 -0600 (MDT)
Date: Thu, 30 May 2013 14:55:39 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Clemens Eisserer <linuxhippy@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfsck errors (fs tree 565 refs 125 not found) - how serious
Message-ID: <20130530185539.GD9829@localhost.localdomain>
References: <CAFvQSYShdQL_pZB12=Xt7dg+yLt0NNCW+WTyOXgic3SbFDy69w@mail.gmail.com>
 <CAFvQSYS1odBm3+ttcuQCZuxmWuVfUkCatQw1bAG_B_uTJVmCmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAFvQSYS1odBm3+ttcuQCZuxmWuVfUkCatQw1bAG_B_uTJVmCmw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 30, 2013 at 12:06:50PM -0600, Clemens Eisserer wrote:
> Hi again,
> 
> I am able to induce the btrfsck errors I experienced using a synthetic
> workload on a fresh filesystem with linux-3.10.0.rc2.
> However as filing the bug-report would take quite some time (uploading
> 512mb trace-files, writing a short read-me, ...) I wonder whether this
> is an issue woth of reporting, or maybe just caused by an outdated
> version of btrfsck (I am using
> btrfs-progs-0.20.rc1.20130308git704a08c-1).
> 

You are running on an unmounted fs right?  Also please make sure you are running
the git version

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

Thanks,

Josef
