Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kivu.grabeuh.com ([212.85.152.17]:46028 "EHLO kivu.grabeuh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab2GSOtn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jul 2012 10:49:43 -0400
Received: from localhost (localhost [127.0.0.1])
	by kivu.grabeuh.com (Postfix) with ESMTP id F17F3800152
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2012 16:49:40 +0200 (CEST)
Received: from kivu.grabeuh.com ([127.0.0.1])
	by localhost (kivu.grabeuh.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 9KIrFSdZ2Kyj for <linux-btrfs@vger.kernel.org>;
	Thu, 19 Jul 2012 16:49:34 +0200 (CEST)
Received: from [127.0.0.1] (nawak.grabeuh.com [212.85.154.15])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: jim)
	by kivu.grabeuh.com (Postfix) with ESMTPSA id AD43DC5DD57
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2012 16:49:34 +0200 (CEST)
Message-ID: <50081E7E.6080202@liotier.org>
Date: Thu, 19 Jul 2012 16:49:34 +0200
From: Jean-Marc Liotier <jm@liotier.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: State of "Hot data tracking and moving to faster devices" functionality
 ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://btrfs.wiki.kernel.org/index.php?title=Main_Page advertises "Hot 
data tracking and moving to faster devices" but as far as I could find 
(http://permalink.gmane.org/gmane.comp.file-systems.btrfs/15884) the 
patches have never been merged. What is known about the future of this 
sort of performance enhancement in BTRFS ?
