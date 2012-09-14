Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:58430 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308Ab2INN7g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 09:59:36 -0400
Date: Fri, 14 Sep 2012 15:59:19 +0200
From: David Sterba <dave@jikos.cz>
To: clinew@linux.vnet.ibm.com
Cc: linux-btrfs@vger.kernel.org, cmm@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] Btrfs-progs: Fix compiler warnings on PPC64.
Message-ID: <20120914135919.GN17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1347492116-16317-1-git-send-email-clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1347492116-16317-1-git-send-email-clinew@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2012 at 04:21:56PM -0700, clinew@linux.vnet.ibm.com wrote:
> Defining __KERNEL__ before the file <asm/types.h>, or any file that
> includes this file, will let PPC64 know to use unsigned long long
> for u64 instead. This patch adds the defines and fixes the print
> warnings on PPC64.

Defining __KERNEL__ in random places does not seem clean, I understand
it in kerncompat.h which should transparently fix any compatibility
issues, and the files like cmd-receive.c should include this instead of
the explicit defines.


david
