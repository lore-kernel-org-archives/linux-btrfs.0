Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab3FKSt2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 14:49:28 -0400
Date: Tue, 11 Jun 2013 10:50:01 -0700
From: Zach Brown <zab@redhat.com>
To: anand jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] btrfs: add framework to read fs info and dev info
 from the kernel
Message-ID: <20130611175001.GM24721@lenny.home.zabbo.net>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
 <1370876355-16584-1-git-send-email-anand.jain@oracle.com>
 <1370876355-16584-3-git-send-email-anand.jain@oracle.com>
 <20130610203054.GK24721@lenny.home.zabbo.net>
 <51B72EC5.3000407@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51B72EC5.3000407@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >1) Have a simple single fixed input structure for each ioctl.  Maybe
> >with some extra padding and a flags argument if you think stuff is going
> >to be added over time.  No generic header.  No casting.  The ioctl
> >number defines the input structure.  If you need a different structure
> >later, use a different ioctl number.
> 
>  -No generic header and No casting-  Why not ?

Because it brings no benefits.  All the supposed benefits can be achived
through careful use of the existing interfaces, ioctl or otherwise.  And
it has costs: code complexity, run-time cpu/memory, etc.  Its
benefit/cost ratio is not flattering :).

- z
