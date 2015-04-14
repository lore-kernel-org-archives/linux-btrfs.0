Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([80.100.93.5]:36447 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbbDNIKh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 04:10:37 -0400
Date: Tue, 14 Apr 2015 10:03:04 +0200
From: Sander <sander@humilis.net>
To: Russell Coker <russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: directory defrag
Message-ID: <20150414080304.GA25393@panda>
Reply-To: sander@humilis.net
References: <201504140737.17826.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201504140737.17826.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker wrote (ao):
> The current defragmentation options seem to only support defragmenting
> named files/directories or a recursive defragmentation of files and
> directories.
> 
> I'd like to recursively defragment directories.

find / -xdev -type d -execdir btrfs filesystem defrag -c {} +

Would that work for you?

	Sander
