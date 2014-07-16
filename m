Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dovecot.logic.tuwien.ac.at ([128.130.175.61]:37510 "EHLO
	mail.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932902AbaGPN00 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 09:26:26 -0400
Date: Wed, 16 Jul 2014 22:19:24 +0900
From: Norbert Preining <preining@logic.at>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: btrfs hanging since 3.16-rc3 or so
Message-ID: <20140716131924.GD23620@auth.logic.tuwien.ac.at>
References: <20140715134046.GX23620@auth.logic.tuwien.ac.at>
 <20140715214701.GD4834@carfax.org.uk>
 <20140716074120.GA29931@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140716074120.GA29931@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

> [PATCH] Btrfs: fix abnormal long waiting in fsync
> https://patchwork.kernel.org/patch/4564961/

Looks fine! And also is explains why aptitude was hanging as it does
several fsync operations.

I will have it running from now and report in case of problems.

Thanks

Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
------------------------------------------------------------------------
