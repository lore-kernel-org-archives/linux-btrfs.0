Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from old.lon-b.elastichosts.com ([84.45.121.3]:48084 "EHLO
	lon-b.elastichosts.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751534AbaFMGr2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 02:47:28 -0400
Message-ID: <539A9E2F.1020209@elastichosts.com>
Date: Fri, 13 Jun 2014 07:46:07 +0100
From: Alin Dobre <alin.dobre@elastichosts.com>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: Deadlock/high load
References: <5399C40F.3070509@elastichosts.com> <20140613033725.GA31905@localhost.localdomain>
In-Reply-To: <20140613033725.GA31905@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13/06/14 04:37, Liu Bo wrote:
> The output of 'btrfs filesystem df' is appreciate, it can help determine if the
> FS has entered into 'almost full' situation, and that may cause a bug that pages
> are not marked with writeback tag and lead to processes's endless waiting.

I'll send it as soon as it happens again, thanks!

Cheers,
Alin.
