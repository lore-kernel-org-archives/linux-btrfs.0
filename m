Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.miceliux.com ([81.4.104.92]:37414 "EHLO mx2.miceliux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbaJGI4D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Oct 2014 04:56:03 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx2.miceliux.com (Postfix) with ESMTP id AB111186336
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Oct 2014 10:47:57 +0200 (CEST)
Received: from mx2.miceliux.com ([127.0.0.1])
	by localhost (mx2.miceliux.com [127.0.0.1]) (amavisd-new, port 10028)
	with ESMTP id nbP1wJCy7KsD for <linux-btrfs@vger.kernel.org>;
	Tue,  7 Oct 2014 10:47:57 +0200 (CEST)
Received: from miceliux.com (unknown [IPv6:2a00:dcc0:dead:a8bb::1])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: juan.orti@miceliux.com)
	by mx2.miceliux.com (Postfix) with ESMTPSA id 03092186333
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Oct 2014 10:47:56 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 07 Oct 2014 10:47:56 +0200
From: Juan Orti Alcaine <juan.orti@miceliux.com>
To: linux-btrfs@vger.kernel.org
Subject: Identify mounted subvolume
Message-ID: <c7a9551462105e36f8ac5f874d19e9c2@miceliux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I cannot find the answer to this one. How can I determine which 
subvolume I have mounted in a certain path? I'm looking through /sys but 
no clue.

Thank you.

-- 
Juan Orti
https://miceliux.com

