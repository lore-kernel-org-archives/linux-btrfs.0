Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f41.google.com ([209.85.216.41]:58209 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaKMAGh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 19:06:37 -0500
Received: by mail-qa0-f41.google.com with SMTP id s7so9551033qap.28
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 16:06:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E8C63C11EA3FB04DBDFEDECEFD927FD1139F9841@US-EVT-EXM04-P.global.tektronix.net>
References: <E8C63C11EA3FB04DBDFEDECEFD927FD1139F9841@US-EVT-EXM04-P.global.tektronix.net>
Date: Thu, 13 Nov 2014 08:06:36 +0800
Message-ID: <CAGQ70esipQcWkjR3=6R-2xPHMEG0vw3JSrxQ_2wDPOiM+wxdqw@mail.gmail.com>
Subject: Re: btrfs balance fails with no space errors (despite having plenty)
From: Oon-Ee Ng <ngoonee.talk@gmail.com>
To: "Kline, Matthew" <matthew.kline@flukenetworks.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 13, 2014 at 2:48 AM, Kline, Matthew
<matthew.kline@flukenetworks.com> wrote:
> Hi all,
>
> Yesterday I converted my ext4 root and home partitions on my home machine
> to btrfs using btrfs-convert. After confirming that everything went well,
> I followed the wiki instructions to nuke the 'ext2_saved" subvolume,
> then defraggad and rebalanced. Everything went according to plan on my root
> partition, but my home partition claimed to have run out of space
> when rebalancing.

I had a similar problem on a btrfs partition (not a converted one) and
had to add a separate partition's space to provide enough
space/metadata space to successfully do a balance. In my case, just a
4GB thumb drive.
