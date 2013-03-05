Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664Ab3CESn0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Mar 2013 13:43:26 -0500
Date: Tue, 5 Mar 2013 10:43:21 -0800
From: Zach Brown <zab@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] during balance operation, WARNING: at
 fs/btrfs/relocation.c:1624 replace_file_extents+0x74b/0x7e0 [btrfs]()
Message-ID: <20130305184321.GF1658@lenny.home.zabbo.net>
References: <5134D8D7.9000501@giantdisaster.de>
 <20130304193137.GA30680@shiny.masoncoding.com>
 <5135DE09.4080605@giantdisaster.de>
 <20130305151121.GE30680@shiny.masoncoding.com>
 <20130305164018.GH30680@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130305164018.GH30680@shiny.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Zach's commit broke that rule, which means I finally get to send him a
> tshirt to celebrate his first btrfs bug.

Hooray!  XL.

- z
