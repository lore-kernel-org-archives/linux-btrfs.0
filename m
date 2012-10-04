Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magrathea.jots.org ([173.208.196.237]:40142 "EHLO magrathea"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965008Ab2JDOpi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Oct 2012 10:45:38 -0400
Received: from webmail.jots.org (localhost.localdomain [127.0.0.1])
	by magrathea (Postfix) with ESMTP id EABAB18820BC6
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Oct 2012 18:36:43 +0400 (MSD)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 04 Oct 2012 10:36:43 -0400
From: "Ken D'Ambrosio" <ken@jots.org>
To: <linux-btrfs@vger.kernel.org>
Subject: Will RAID have issues with disks that spin =?UTF-8?Q?down=3F?=
Message-ID: <d33ad0cb427c4885092e4440b5a140cb@jots.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.  I know that several hardware RAID solutions have issues with disks 
that spin down when idle; the time to spin back up -- usually on the 
order of five seconds -- causes unhappy timeouts, etc.  I was wondering 
if that would be an issue with RAID a-la btrfs?

Thanks,

-Ken
