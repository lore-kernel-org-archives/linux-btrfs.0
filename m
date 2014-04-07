Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from datenkhaos.de ([81.89.99.198]:42715 "EHLO datenkhaos.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254AbaDGM0P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 08:26:15 -0400
Date: Mon, 7 Apr 2014 14:18:41 +0200
From: Johannes Hirte <johannes.hirte@datenkhaos.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: =?ISO-8859-1?B?U3fibWk=?= Petaramesh <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS setup advice for laptop performance ?
Message-ID: <20140407141841.476f8aae@datenkhaos.de>
In-Reply-To: <533EA686.5030909@gmail.com>
References: <2692878.dRG1K49eOP@fnix>
	<533EA686.5030909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 04 Apr 2014 08:33:10 -0400
Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:

> On 2014-04-04 04:02, Swâmi Petaramesh wrote:
> > - Is it still recommended to mkfs with a nodesize or leafsize
> > different (bigger) than the default ? I wouldn't like to lose too
> > much disk space anyway (1/2 nodesize per file on average ?), as it
> > will be limited...
> This depends on many things, the average size of the files on the disk
> is the biggest factor.  In general you should get the best disk
> utilization by setting nodesize so that a majority of the files are
> less than the leafsize minus 256 bytes, and all but a few are smaller
> than two times the leafsize minus 256 bytes.  However, if you want to
> really benefit from the data compression, you should just use the
> smallest leaf/nodesize for your system (which is what mkfs defaults
> to), as data that gets as BTRFS stores files whose size is at least
> (roughly) 256 bytes less than the leafsize inline with the metadata,
> and doesn't compress such files.

With commit c652e4efb8e2dd76ef1627d8cd649c6af5905902 the default
node-/leafsize has changed:

commit c652e4efb8e2dd76ef1627d8cd649c6af5905902
Author: Chris Mason <chris.mason@fusionio.com>
Date:   Fri Nov 8 13:51:52 2013 -0500

    mkfs: change default metadata blocksize to 16KB

