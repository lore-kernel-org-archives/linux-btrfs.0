From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs panic - BUG: soft lockup - CPU#0 stuck for 61s!
	[fs_mark:4573]
Date: Thu, 5 Jun 2008 10:34:28 -0400
Message-ID: <20080605143428.GA16999@think.oraclecorp.com>
References: <4844336F.1010807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4844336F.1010807@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 02, 2008 at 01:52:47PM -0400, Ric Wheeler wrote:
>
> I can reliably get btrfs to panic by running my fs_mark code on a newly  
> created file system with lots of threads on an 8-way box. If this is too  
> aggressive, let me know ;-)
>
> Here is a summary of the panic:

BTW, exactly how are you running fs_mark?  Mingming reminded me that
strictly speaking this patch shouldn't be required, so there might be
other related problems.

-chris

