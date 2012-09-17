Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33445 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab2IQQVD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 12:21:03 -0400
Received: from pyramind.ukuu.org.uk (earthlight.etchedpixels.co.uk [81.2.110.250])
	by lxorguk.ukuu.org.uk (8.14.5/8.14.1) with ESMTP id q8HGrVj1007679
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 17:53:37 +0100
Received: from pyramind.ukuu.org.uk (localhost [127.0.0.1])
	by pyramind.ukuu.org.uk (8.14.5/8.14.5) with ESMTP id q8HGPsGK014666
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 17:25:56 +0100
Date: Mon, 17 Sep 2012 17:25:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: This code cannot be right
Message-ID: <20120917172554.134b2014@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


ctree.c:btrfs_insert_some_items()
{
...


		if (total_size + data_size[i]+ ...
		{
			break;
			nr = i;
		}


