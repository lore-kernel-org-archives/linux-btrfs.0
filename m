Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58431 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbbJBUlO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Oct 2015 16:41:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zi78g-0006Nd-8m
	for linux-btrfs@vger.kernel.org; Fri, 02 Oct 2015 22:41:10 +0200
Received: from 92.243.181.209 ([92.243.181.209])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Oct 2015 22:41:10 +0200
Received: from matwey.kornilov by 92.243.181.209 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Oct 2015 22:41:10 +0200
To: linux-btrfs@vger.kernel.org
From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Subject: btrfs: user space tool to force compression
Date: Fri, 2 Oct 2015 23:41:00 +0300
Message-ID: <mumq4s$g1c$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Is there a way (and appropriate user space tool) to force compression of
existing file? I mean there was directory with some content and then I
set compression attribute (property) to it. How to force data recompression?

