Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33988 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab3IJRkK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 13:40:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VJRv1-0003yp-Sg
	for linux-btrfs@vger.kernel.org; Tue, 10 Sep 2013 19:40:04 +0200
Received: from 188.158.24.105 ([188.158.24.105])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Sep 2013 19:40:03 +0200
Received: from celecao70 by 188.158.24.105 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Sep 2013 19:40:03 +0200
To: linux-btrfs@vger.kernel.org
From: enzo ferrari <celecao70@gmail.com>
Subject: separating data and metadata
Date: Tue, 10 Sep 2013 17:34:28 +0000 (UTC)
Message-ID: <loom.20130910T193110-444@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

any idea about separating Btrfs' data and metadata to improve the security
of flash storage?

