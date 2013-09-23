Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51780 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab3IWQzt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 12:55:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VO9QC-0000jA-65
	for linux-btrfs@vger.kernel.org; Mon, 23 Sep 2013 18:55:40 +0200
Received: from 141ob.scansafe.net ([72.37.171.164])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 18:55:40 +0200
Received: from dustymabe by 141ob.scansafe.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 18:55:40 +0200
To: linux-btrfs@vger.kernel.org
From: Dusty Mabe <dustymabe@gmail.com>
Subject: Re: [PATCH 0/9] enhance btrfs qgroup show command
Date: Mon, 23 Sep 2013 16:55:13 +0000 (UTC)
Message-ID: <loom.20130923T185309-168@post.gmane.org>
References: <50C068D4.6020105@cn.fujitsu.com> <loom.20130922T170658-776@post.gmane.org> <523F95C4.1080404@cn.fujitsu.com> <CAFfJ-R46gqeMOH3bKPPnghmPZ7CziTmYghXJhgOzEoQ_vTJ6Pw@mail.gmail.com> <523FA4EB.3060201@cn.fujitsu.com> <pan$a3bb6$bcc83f63$430b22dd$bd36c43d@cox.net> <F83FBE02-86FA-4CE3-9EB1-4D275AF6A41C@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wang Shilong <wangshilong1991 <at> gmail.com> writes:

> 
> 
> In Dusty's reproduced steps, there are no parent qgroups. So i think every
> qgroup should works as expected, if negative numbers come out, it must
> be a *bug*.

In that case would you like for me to open a new bug report with the details?


Dusty 

