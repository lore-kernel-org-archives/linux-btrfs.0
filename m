Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:51770 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbbAPBFk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 20:05:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 16 Jan 2015 10:05:35 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs@vger.kernel.org
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: Kernel bug in 3.19-rc4
Message-ID: <672b579b39da1cc6fa5f91ba4b964731@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I just started some btrfs stress testing on latest linux kernel 
> 3.19-rc4:
> A few hours later, filesystem stopped working - the kernel bug report
> can be found below.

Hi,

your "kernel BUG at fs/btrfs/inode.c:3142!" from 3.19-rc4 corresponds to 
http://marc.info/?l=linux-btrfs&m=141903172106342&w=2 - it was "kernel 
BUG at /home/apw/COD/linux/fs/btrfs/inode.c:3123!" in 3.18.1, and is 
exactly the same code in both cases:


         /* grab metadata reservation from transaction handle */
         if (reserve) {
                 ret = btrfs_orphan_reserve_metadata(trans, inode);
                 BUG_ON(ret); /* -ENOSPC in reservation; Logic error? JDM 
*/
         }


-- 
Tomasz Chmielewski
http://www.sslrack.com

