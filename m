Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38710 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988AbcCDCxE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 21:53:04 -0500
Subject: Re: [RFC] Experimental btrfs encryption
To: Alex Elsayed <eternaleye@gmail.com>, linux-btrfs@vger.kernel.org
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
 <56D63CB1.5070202@cn.fujitsu.com> <loom.20160303T111025-895@post.gmane.org>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56D8F882.4090808@oracle.com>
Date: Fri, 4 Mar 2016 10:52:50 +0800
MIME-Version: 1.0
In-Reply-To: <loom.20160303T111025-895@post.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> The way btrfs encryption interacts with the keyring APIs is important, and
> "reconsidering later" will potentially represent an API/ABI break. Please
> keep it in mind.

  Yep. We would take considerable time to get the API frozen and
  integrated, as once its in, its there forever. So there are
  warnings as experimental / RFC.

Thanks, Anand
