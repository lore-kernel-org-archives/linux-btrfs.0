Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.miceliux.com ([81.4.104.92]:58681 "EHLO mx2.miceliux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbaJ1URi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 16:17:38 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx2.miceliux.com (Postfix) with ESMTP id C0FDF1B70DF
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 21:17:28 +0100 (CET)
Received: from mx2.miceliux.com ([127.0.0.1])
	by localhost (mx2.miceliux.com [127.0.0.1]) (amavisd-new, port 10028)
	with ESMTP id yXTX2zo2seFE for <linux-btrfs@vger.kernel.org>;
	Tue, 28 Oct 2014 21:17:27 +0100 (CET)
Received: from [IPv6:2001:470:7950:10::2] (xenon.miceliux.com [IPv6:2001:470:7950:10::2])
	(using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: juan.orti@miceliux.com)
	by mx2.miceliux.com (Postfix) with ESMTPSA id 3041F1B70D7
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 21:17:27 +0100 (CET)
Message-ID: <1414527446.13613.1.camel@xenon.lan>
Subject: Re: Unable to fixup (regular) error in RAID1 fs
From: Juan Orti <juan.orti@miceliux.com>
To: linux-btrfs@vger.kernel.org
Date: Tue, 28 Oct 2014 21:17:26 +0100
In-Reply-To: <a3d3305c6149a1aa5e2b3f29d76fff93@miceliux.com>
References: <a3d3305c6149a1aa5e2b3f29d76fff93@miceliux.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

El mar, 28-10-2014 a las 16:54 +0100, Juan Orti escribió:
> I'm seeing these errors in a RAID1 fs:
> (...)
> Why can't it fix the errors? a bad device? smartctl says the disk is ok. 
> I'm currently running a full scrub to see if it finds more errors. What 
> should I do?
> 

Well, the scrub has finished without errors. Should I worry or not?


-- 
Juan Orti
https://miceliux.com



