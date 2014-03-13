Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25655 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbaCMUUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 16:20:11 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: Testing BTRFS
From: Avi Miller <avi.miller@oracle.com>
In-Reply-To: <5321F4A7.8080003@benjamindsmith.com>
Date: Fri, 14 Mar 2014 07:20:06 +1100
Cc: linux-btrfs@vger.kernel.org
Message-Id: <58CFC156-C56B-4618-9336-EC1033EF8155@oracle.com>
References: <loom.20140306T191655-366@post.gmane.org>	<pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>	<loom.20140307T144540-512@post.gmane.org> <pan$72cea$1961f20d$d4386bc$889c1510@cox.net> <531E5B44.6030502@benjamindsmith.com> <DFAE9B5E-2C12-4215-B4CA-016CBD4575EC@oracle.com> <5321F4A7.8080003@benjamindsmith.com>
To: Lists <lists@benjamindsmith.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 14 Mar 2014, at 5:10 am, Lists <lists@benjamindsmith.com> wrote:

> Is there any issue with BTRFS and 32 bit O/S like with ZFS?

We provide some btrfs support with the 32-bit UEK Release 2 on OL6, but we strongly recommend only using the UEK Release 3 which is 64-bit only.

--
Oracle <http://www.oracle.com>
Avi Miller | Product Management Director | +61 (3) 8616 3496
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia

