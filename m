Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:52466 "EHLO pim.lukas-pirl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbbKSXxj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 18:53:39 -0500
Received: from [192.168.1.5] (unknown [119.224.19.150])
	by pim.lukas-pirl.de (Postfix) with ESMTPSA id 6BEA61FB2733
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2015 23:53:37 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: Lukas Pirl <btrfs@lukas-pirl.de>
Subject: anything wrong with `balance -dusage -musage` together?
Message-ID: <564E60FD.1010801@lukas-pirl.de>
Date: Fri, 20 Nov 2015 12:53:33 +1300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

I rarely see balance used with -dusage -musage together, esp. with
values other than zero.

The question is, is there anything wrong with running (say) `balance
-dusage=50 -musage=30` regularly?

Thanks and best regards,

Lukas
