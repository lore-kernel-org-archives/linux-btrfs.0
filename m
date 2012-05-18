Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:57016 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab2ERQVI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 12:21:08 -0400
Date: Fri, 18 May 2012 18:20:51 +0200
From: David Sterba <dave@jikos.cz>
To: Brendan Smithyman <smithyman@gmail.com>
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org, miaox@cn.fujitsu.com
Subject: Re: Subdirectory creation on snapshot
Message-ID: <20120518162051.GK24394@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <821DC50D-8451-4AD1-8CCA-DE1238D4788B@gmail.com>
 <20120509165802.GN19331@twin.jikos.cz>
 <F39B4ABB-65D7-467D-BB57-FD9EBB70F1FB@gmail.com>
 <20120514120852.GH25501@twin.jikos.cz>
 <20120514162707.GA24394@twin.jikos.cz>
 <687632B7-2461-496A-878C-2357B47128CF@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <687632B7-2461-496A-878C-2357B47128CF@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2012 at 10:11:01AM -0700, Brendan Smithyman wrote:
> The disks that *are* still showing the subdirectory creation issue
> were both converted from ext4 (using old tools).  So perhaps that's a
> direction to explore.

Yeah, thanks for the hint.

david
