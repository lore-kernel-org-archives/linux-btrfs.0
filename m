Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45711 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353AbbK3QsI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 11:48:08 -0500
Date: Mon, 30 Nov 2015 11:48:01 -0500
From: Chris Mason <clm@fb.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Bug/regression: Read-only mount not read-only
Message-ID: <20151130164801.GD2162@ret.masoncoding.com>
References: <20151128134634.GF24333@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20151128134634.GF24333@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 28, 2015 at 01:46:34PM +0000, Hugo Mills wrote:
>    We've just had someone on IRC with a problem mounting their FS. The
> main problem is that they've got a corrupt log tree. That isn't the
> subject of this email, though.
> 
>    The issue I'd like to raise is that even with -oro as a point
> option, the FS is trying to replay the log tree. The dmesg output from
> mount -oro is at the end of the email.
> 
>    Now, my memory, experience and understanding is that the FS
> doesn't, and shouldn't replay the log tree on a RO mount, because the
> FS should still be consistent even without the reply, and
> RO-means-actually-RO is possible and desirable. (Compared to a
> journalling FS, where journal replay is required for a consistent,
> usable FS).
> 
>    So, this looks to me like a regression that's come in somewhere.
> 
>    (Just for completeness, the system in question usually runs 4.2.5,
> but the live CD the OP is using is 4.2.3).

We do need to replay the log tree, even on readonly mounts.  Otherwise
files created and fsunk before crashing may not even exist.

We'll bail out of the log replay on readonly media, but otherwise the
replay always happens.

-chris
