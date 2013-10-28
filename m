Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:38969 "EHLO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3J1Lzc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Oct 2013 07:55:32 -0400
Date: Mon, 28 Oct 2013 12:56:00 +0100
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: Christian Robert <christian.robert@polymtl.ca>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Why cannot I move a read-only snapshot around?
Message-ID: <20131028115600.GB6847@kipc2.localdomain>
References: <20131024152955.GA6110@kipc2.localdomain>
 <pan$85344$b336f5bf$ca444091$a3ef1e0c@cox.net>
 <20131024220919.GB14128@kipc2.localdomain>
 <526B56DE.6060105@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <526B56DE.6060105@polymtl.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat 131026, Christian Robert wrote:
> you can change a "ro" snapshot into a "rw" snapshot

> you just snapshot it without the -r" option

Yes, I know but the new rw snapshots are not really identical
in terms of ID, generation count and UUID (the file contents will
remain the same of course).

The question is how this will affect btrfs send and receive,
especially considering the -p and -c option.

Karl

