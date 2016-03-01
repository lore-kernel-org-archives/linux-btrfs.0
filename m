Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47328 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686AbcCAQqX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Mar 2016 11:46:23 -0500
Date: Tue, 1 Mar 2016 11:46:16 -0500
From: Chris Mason <clm@fb.com>
To: Tomasz Torcz <tomek@pipebreaker.pl>, <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC] Experimental btrfs encryption
Message-ID: <20160301164616.dbbeuzccfkzupign@floor.thefacebook.com>
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
 <20160301162952.GB718307@mother.pipebreaker.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <20160301162952.GB718307@mother.pipebreaker.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 01, 2016 at 05:29:52PM +0100, Tomasz Torcz wrote:
> On Wed, Mar 02, 2016 at 12:08:09AM +0800, Anand Jain wrote:
> > This patchset adds btrfs encryption support.
> > 
> > Warning:
> > The code is in prototype/experimental stage and is not suitable
> > for the production data yet.
> 
>   Can you share some design documents?  Will it be compatible
> with existing encrypting filesystems:
>  – ext4 ?
>  – ZFS ?
> 
>   It would be nice to have common API for encryption, not a dozen
> of filesystem-specific interfaces.

We'll definitely move in line with the common API over time.  Thanks
Anand for starting this!

I'd prefer that we keep it per-subvolume for now, just because
subvolumes are so cheap and because it seems like a better collection
point for general use.  But as the other filesystems add features we'll
make sure and keep parity with what users expect.

-chris

