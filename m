Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:57725 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbaHEOXK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Aug 2014 10:23:10 -0400
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs and iostat - how do I measure the live performance of my  btrsf =?UTF-8?Q?filesystems=3F?=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 05 Aug 2014 16:14:36 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: rbellamy@pteradigm.com
Message-ID: <e464a0229fbd354aea0d15d8342330b1@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> root@a i ~ # iostat
> Linux 3.14.15-1-lts (eanna) 08/04/2014 _x86_64_ (24 CPU)
> 
> (...)
> 
> How do I boil those numbers down to something meaningful, so I can get
> an idea of the throughput in situ?

Simple iostat won't give you meaningful live performance stats.

You can combine it i.e. like below:

iostat -x 1
iostat -mx 1
iostat -m 1

etc.



-- 
Tomasz Chmielewski
http://www.sslrack.com

