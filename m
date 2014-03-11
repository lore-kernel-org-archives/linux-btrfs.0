Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from locke.effortlessis.com ([208.53.66.14]:40580 "EHLO
	locke.effortlessis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaCKAs0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 20:48:26 -0400
Received: from tesla.schoolpathways.com (173-166-236-97-sacramento.hfc.comcastbusiness.net [173.166.236.97])
	by locke.effortlessis.com (Postfix) with ESMTPSA id 288F344907
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Mar 2014 00:39:33 +0000 (UTC)
Message-ID: <531E5B44.6030502@benjamindsmith.com>
Date: Mon, 10 Mar 2014 17:39:32 -0700
From: Lists <lists@benjamindsmith.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Testing BTRFS
References: <loom.20140306T191655-366@post.gmane.org>	<pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>	<loom.20140307T144540-512@post.gmane.org> <pan$72cea$1961f20d$d4386bc$889c1510@cox.net>
In-Reply-To: <pan$72cea$1961f20d$d4386bc$889c1510@cox.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'd like to begin testing BTRFS. We'd probably begin roll out in 6 
months to a year if testing goes well.

We're currently using CentOS6/64 everywhere, are aware of BTRFS being a 
"Technology preview" in RHEL 7beta and would like to begin testing 
production-level load testing. We generate about 10 GB of distinct data 
daily that is stored redundantly by default on a combination of ZFS and 
Ext4.

Is there a "recommended way" to do this? Is it anywhere as easy as 
ZFSonLinux yum install?

-Ben
