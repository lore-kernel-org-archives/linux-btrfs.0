Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbaBQRWG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Feb 2014 12:22:06 -0500
Message-ID: <5302453B.8000509@redhat.com>
Date: Mon, 17 Feb 2014 11:22:03 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: know mount location with in FS
References: <5300D31E.6000600@oracle.com>
In-Reply-To: <5300D31E.6000600@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/16/14, 9:02 AM, Anand Jain wrote:
> 
> Hello,
> 
> I wonder if there is any known way to get the mount point directory name with in the btrfs-kernel ?

For what reason?

Remember that a single block device can be mounted in multiple places (or bind-mounted, etc), so there is not even necessarily a single answer to that question.

-Eric

