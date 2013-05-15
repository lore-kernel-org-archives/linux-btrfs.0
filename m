Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:5440 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932875Ab3EOQnZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 12:43:25 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:50796 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80)
	(envelope-from <lists@colorremedies.com>)
	id 1UcenS-002WHg-RU
	for linux-btrfs@vger.kernel.org; Wed, 15 May 2013 10:43:22 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: subvol copying
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <kmve61$cqe$1@ger.gmane.org>
Date: Wed, 15 May 2013 10:43:23 -0600
Message-Id: <4BF95473-B35B-4B3B-9437-24448B279AB1@colorremedies.com>
References: <201305151525.27913.russell@coker.com.au> <kmve61$cqe$1@ger.gmane.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 15, 2013, at 1:40 AM, Gabriel de Perthuis <g2p.code@gmail.com> wrote:

> 
> You can move subvolumes at any time, as if they were regular directories.

In the example case, the subvolumes are read-only. So is it possible to make a read-only subvolume (snapshot) read-writable? And is it possible to make a read-writeable snapshot of a read-only subvolume?


Chris Murphy

