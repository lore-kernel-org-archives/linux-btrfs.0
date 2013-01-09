Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outgoing.tormail.org ([82.221.96.22]:33020 "EHLO
	outgoing.tormail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab3AIDfr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2013 22:35:47 -0500
Date: Wed, 9 Jan 2013 03:35:56 +0000
From: junlion@tormail.org
To: linux-btrfs@vger.kernel.org
Cc: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: chattr +C  vs.  btrfs subvolume snapshot
References: <1TsN9p-000FDf-SX@internal.tormail.org>
 <20130108032808.GB1916@liubo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130108032808.GB1916@liubo>
Message-Id: <1TsmQI-000Ivt-Dx@internal.tormail.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-01-08 11:28 +0800, Liu Bo wrote:
> And for the fragmentation, do you mean 'filefrag'?

I was for something that would show how the data branches off across
different snapshots, --reflink copies etc.

filefrag looks interesting, thanks.
