Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay004-omc1s10.hotmail.com ([65.54.190.21]:54064 "EHLO
	BAY004-OMC1S10.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751859AbbAGTDm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Jan 2015 14:03:42 -0500
Message-ID: <BAY172-W45E04898674EAB817BB2D9B0460@phx.gbl>
From: Kyle Gates <kylegates@hotmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: ssd mode on rotational media
Date: Wed, 7 Jan 2015 12:55:41 -0600
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What issues would arise if ssd mode is activated because of a block layer setting the rotational flag to zero? This happens for me running btrfs on bcache. Would it be beneficial to pass the no_ssd flag?
Thanks,
Kyle
 		 	   		  