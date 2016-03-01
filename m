Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 185-6-29-55-rev.logitus.pl ([185.6.29.55]:38770 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbcCAQfr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 11:35:47 -0500
Date: Tue, 1 Mar 2016 17:29:52 +0100
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Experimental btrfs encryption
Message-ID: <20160301162952.GB718307@mother.pipebreaker.pl>
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 02, 2016 at 12:08:09AM +0800, Anand Jain wrote:
> This patchset adds btrfs encryption support.
> 
> Warning:
> The code is in prototype/experimental stage and is not suitable
> for the production data yet.

  Can you share some design documents?  Will it be compatible
with existing encrypting filesystems:
 – ext4 ?
 – ZFS ?

  It would be nice to have common API for encryption, not a dozen
of filesystem-specific interfaces.

-- 
Tomasz Torcz                                                       72->|   80->|
xmpp: zdzichubg@chrome.pl                                          72->|   80->|

