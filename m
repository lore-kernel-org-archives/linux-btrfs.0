Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:36874 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbcAFNMG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jan 2016 08:12:06 -0500
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 5A6E420C029
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jan 2016 00:02:10 +1100 (AEDT)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 03786-08 for <linux-btrfs@vger.kernel.org>;
 Thu,  7 Jan 2016 00:02:10 +1100 (AEDT)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPSA id 0113520C026
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jan 2016 00:02:09 +1100 (AEDT)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: sendfile(2) not killable on btrfs
Date: Thu, 07 Jan 2016 00:02:07 +1100
Message-ID: <1857622.QQxRQMXbK2@quad>
In-Reply-To: <CAG8fp8T9=_HFHYayh=hP-VOa-DD2+G5Fg-dLv9SJr9wGhybA6w@mail.gmail.com>
References: <CAG8fp8T9=_HFHYayh=hP-VOa-DD2+G5Fg-dLv9SJr9wGhybA6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 6 Jan 2016 06:08:46 PM Akihiro Suda wrote:

> However, it is still not killable on btrfs.

Your bugzilla entry is for the 4.2 kernel in the current Ubuntu, but this 
patch was only merged into the mainline for at v4.3-rc6-123-g296291c so unless 
it was backported by Canonical it won't be present.

Could you test with the 4.3 kernel please?

http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.3.3-wily/

cheers!
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

