Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24835 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaCaEHJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 00:07:09 -0400
Message-ID: <5338E9EA.9090608@oracle.com>
Date: Mon, 31 Mar 2014 12:07:06 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Cannot add device "is mounted" for unmounted drive that used
 to be in raidset that is mounted
References: <20140323180907.GA22171@merlins.org>
In-Reply-To: <20140323180907.GA22171@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 24/03/2014 02:09, Marc MERLIN wrote:
> I found out that a drive that used to be part of a raid system that is mounted
> and running without it, btrfs apparently decides that the drive is part of the mounted
> raidset and in use.

  yes. A known issue its in the list to fix.

-Anand
