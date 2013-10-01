Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23636 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab3JAPmQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 11:42:16 -0400
Date: Tue, 1 Oct 2013 23:42:03 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix crash of compressed writes
Message-ID: <20131001154146.GA5605@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1380544797-29798-1-git-send-email-bo.li.liu@oracle.com>
 <20130930170249.GO18681@localhost.localdomain>
 <20131001033721.GA32575@localhost.localdomain>
 <20131001123830.GE27490@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131001123830.GE27490@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 01, 2013 at 08:38:30AM -0400, Josef Bacik wrote:
> No we needed his other addition below which is important, for when the delalloc
> range starts before but still encompasses our page.  The other part is not
> needed, we should be returning 0 if delalloc_end lands before or on our start,
> which should fix your bug and make it a bit more sane.

Got it, I'm sending a new version.

-liubo
