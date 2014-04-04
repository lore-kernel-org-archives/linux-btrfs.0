Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37032 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbaDDAlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Apr 2014 20:41:21 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: Hard restart required
From: Avi Miller <avi.miller@oracle.com>
In-Reply-To: <533DFC46.8020704@benjamindsmith.com>
Date: Fri, 4 Apr 2014 11:41:16 +1100
Cc: linux-btrfs@vger.kernel.org
Message-Id: <EDB7426B-B4CA-45F7-A8A4-F7CD0C876DC8@oracle.com>
References: <533DFC46.8020704@benjamindsmith.com>
To: Lists <lists@benjamindsmith.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 4 Apr 2014, at 11:26 am, Lists <lists@benjamindsmith.com> wrote:

> UUID should work, right? Why else have a UUID if not? 

UUID should work fine on OL6. Can you confirm that you have the UEK3 (3.8.18) kernel running? If you’ve installed from OL6U5 media, it should be enabled by default, but older OL6 ISOs only had UEK2 on the media and the UEK3 yum channel would need to be manually enabled.

Cheers,
Avi

--
Oracle <http://www.oracle.com>
Avi Miller | Product Management Director | +61 (3) 8616 3496
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia

