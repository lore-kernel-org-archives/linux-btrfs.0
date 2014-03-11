Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28723 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbaCKBC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 21:02:28 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: Testing BTRFS
From: Avi Miller <avi.miller@oracle.com>
In-Reply-To: <531E5B44.6030502@benjamindsmith.com>
Date: Tue, 11 Mar 2014 12:02:22 +1100
Cc: linux-btrfs@vger.kernel.org
Message-Id: <DFAE9B5E-2C12-4215-B4CA-016CBD4575EC@oracle.com>
References: <loom.20140306T191655-366@post.gmane.org>	<pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>	<loom.20140307T144540-512@post.gmane.org> <pan$72cea$1961f20d$d4386bc$889c1510@cox.net> <531E5B44.6030502@benjamindsmith.com>
To: Lists <lists@benjamindsmith.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 11 Mar 2014, at 11:39 am, Lists <lists@benjamindsmith.com> wrote:

> Is there a "recommended way" to do this? Is it anywhere as easy as ZFSonLinux yum install?

Oracle Linux 6 with the Unbreakable Enterprise Kernel Release 2 or Release 3 has production-ready btrfs support. You can even convert your existing CentOS6 boxes across to Oracle Linux 6 in-place without reinstalling:

http://linux.oracle.com/switch/centos/

Oracle also now provides all errata, including security and bug fixes for free at http://public-yum.oracle.com and our kernel source code can be found at https://oss.oracle.com/git/

Cheers,
Avi

--
Oracle <http://www.oracle.com>
Avi Miller | Product Management Director | +61 (3) 8616 3496
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia

