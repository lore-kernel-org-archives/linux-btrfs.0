Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32318 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaEVCCO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 22:02:14 -0400
Message-ID: <537D5B55.1010207@oracle.com>
Date: Thu, 22 May 2014 10:05:09 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org
CC: rm@romanrm.net
Subject: Re: [PATCH 1/2 v2] btrfs: label should not contain return char
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com> <1400567808-9494-1-git-send-email-anand.jain@oracle.com> <537B83AD.5010901@redhat.com>
In-Reply-To: <537B83AD.5010901@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>
> (Random aside: why does btrfs support online fs relabeling, anyway?)
>
> -Eric

   Online you mean when mounted ?

   But I had an opinion that should we support label store from the sysfs
   interface when the (sysfs) interface can't communicate the module's
   specific errors back to the user.?

Thanks
