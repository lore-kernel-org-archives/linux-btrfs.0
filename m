Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:48530 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab3HTTfh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 15:35:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21011.50282.877683.245254@localhost.localdomain>
Date: Tue, 20 Aug 2013 21:32:58 +0200
From: lutz.euler@freenet.de (Lutz Euler)
To: Josef Bacik <jbacik@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: BUG at fs/btrfs/relocation.c:1055 during balance.
In-Reply-To: <20130820181053.GG3990@localhost.localdomain>
References: <21010.37299.189607.141474@localhost.localdomain>
	<20130820163840.GF3990@localhost.localdomain>
	<21011.42147.72271.724888@localhost.localdomain>
	<20130820181053.GG3990@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:

> Yup it's
> 
> Btrfs: change how we queue blocks for backref checking

Thanks, found it.

Greetings,

Lutz
