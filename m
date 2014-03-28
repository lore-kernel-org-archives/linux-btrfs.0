Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43735 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaC1Vmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Mar 2014 17:42:50 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: RHEL/CentOS or Debian for stable deployment
From: Avi Miller <avi.miller@oracle.com>
In-Reply-To: <CABgvyo_b19P2QPzszv6Vxc2iHOceP-ndCp1oUzO6Hc=Z4CiJ=A@mail.gmail.com>
Date: Sat, 29 Mar 2014 08:42:46 +1100
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <CF9CC748-3700-4D4F-AB96-03F27EA9C32B@oracle.com>
References: <CABgvyo_b19P2QPzszv6Vxc2iHOceP-ndCp1oUzO6Hc=Z4CiJ=A@mail.gmail.com>
To: =?windows-1252?Q?Johan_Kr=F6ckel?= <johan.kroeckel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 28 Mar 2014, at 11:29 pm, Johan Kröckel <johan.kroeckel@gmail.com> wrote:

> Which source for the kernel binaries would you use, to get stable
> btrfs support together with mentioned service?

Have you considered Oracle Linux? We are continually backporting btrfs fixes and enhancements to our Unbreakable Enterprise Kernel releases. On Oracle Linux 6, you would run the UEK Release 3, which is based on 3.8 mainline with upstream fixes. We also provide all security and bug fix errata for free via http://public-yum.oracle.com, so you don’t need to buy support to run Oracle Linux at keep up-to-date.

Cheers,
Avi

--
Oracle <http://www.oracle.com>
Avi Miller | Product Management Director | +61 (3) 8616 3496
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia

