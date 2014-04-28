Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:39653 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbaD1UDs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Apr 2014 16:03:48 -0400
Date: Mon, 28 Apr 2014 15:00:06 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Which companies contribute to Btrfs?
Message-ID: <20140428150006.087c2357@lwn.net>
In-Reply-To: <20140424011834.GN26949@merlins.org>
References: <20140424011834.GN26949@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 23 Apr 2014 18:18:34 -0700
Marc MERLIN <marc@merlins.org> wrote:

> I writing slides about btrfs for an upcoming talk (at linuxcon) and I was
> trying to gather a list of companies that contribute code to btrfs.

So I just ran into this now.  I did a quick gitdm run over the entire btrfs
history in the kernel and came up with this:

	Top changeset contributors by employer
	Oracle                    1249 (33.2%)
	Fujitsu                    613 (16.3%)
	Red Hat                    483 (12.8%)
	Fusion-IO                  296 (7.9%)
	(None)                     288 (7.6%)
	Novell                     203 (5.4%)
	STRATO AG                  152 (4.0%)
	Couchbase                  106 (2.8%)
	(Consultant)                62 (1.6%)
	(Unknown)                   54 (1.4%)
	Intel                       48 (1.3%)
	New Dream Network           36 (1.0%)
	Facebook                    31 (0.8%)
	IBM                         20 (0.5%)
	FOSS Outreach Program for Women   12 (0.3%)
	Google                      12 (0.3%)
	(Academia)                  11 (0.3%)
	Parallels                   11 (0.3%)
	HP                          10 (0.3%)
	Datera Inc.                  5 (0.1%)

I would expect the rankings to change a bit in the near future, if those
slackers at Facebook ever get it in gear...:)

jon
