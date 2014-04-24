Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969AbaDXLj6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 07:39:58 -0400
Date: Thu, 24 Apr 2014 13:39:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Which companies contribute to Btrfs?
Message-ID: <20140424113956.GA5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140424011834.GN26949@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140424011834.GN26949@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 23, 2014 at 06:18:34PM -0700, Marc MERLIN wrote:
> I writing slides about btrfs for an upcoming talk (at linuxcon) and I was
> trying to gather a list of companies that contribute code to btrfs.

https://btrfs.wiki.kernel.org/index.php/Main_Page

"[...] Jointly developed at Oracle, Red Hat, Fujitsu, Intel, SUSE, STRATO [...]"

> Are there other companies I missed?

STRATO, the guys who wrote scrub, integrity checker, quotas, device stats,
device-replace and portions of send/receive.
