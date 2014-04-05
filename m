Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40657 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaDEBvx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 21:51:53 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: Hard restart required
From: Avi Miller <avi.miller@oracle.com>
In-Reply-To: <76C074C2-E0F3-4E01-AF95-94164948A52B@oracle.com>
Date: Sat, 5 Apr 2014 12:51:49 +1100
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <DAD86790-9441-4459-A860-7836D138DC95@oracle.com>
References: <533DFC46.8020704@benjamindsmith.com> <EDB7426B-B4CA-45F7-A8A4-F7CD0C876DC8@oracle.com> <533EDD2E.6090308@benjamindsmith.com> <EE50E6C7-94F9-494A-A930-194FABFC6B68@oracle.com> <533F3732.6090108@benjamindsmith.com> <76C074C2-E0F3-4E01-AF95-94164948A52B@oracle.com>
To: Lists <lists@benjamindsmith.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 5 Apr 2014, at 12:48 pm, Avi Miller <avi.miller@oracle.com> wrote:

> It has a different name from the default kernel, so both can be installed at the same time. Because this is a switched box, a yum upgrade won’t automatically pull in the UEK because there isn’t an existing one to upgrade.

It’s been a while since I switched a CentOS box, but you might find installing oraclelinux-release will pull in a bunch of the updated packages. I can’t recall if the switch script does this automatically or not, though.

--
Oracle <http://www.oracle.com>
Avi Miller | Product Management Director | +61 (3) 8616 3496
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia

