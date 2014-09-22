Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postler.lichtfels.com ([78.46.92.195]:39423 "EHLO
	postler.lichtfels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbaIVME2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 08:04:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by postler.lichtfels.com (Postfix) with ESMTP id 56BB7123DE
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 14:04:27 +0200 (CEST)
Received: from postler.lichtfels.com ([127.0.0.1])
 by localhost (postler.lichtfels.com [127.0.0.1]) (amavisd-maia, port 10024)
 with LMTP id 30725-05 for <linux-btrfs@vger.kernel.org>;
 Mon, 22 Sep 2014 14:04:25 +0200 (CEST)
Received: from hiro.oops.intern (mail.oops.co.at [213.129.238.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by postler.lichtfels.com (Postfix) with ESMTPSA id 8C16E123C9
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 14:04:25 +0200 (CEST)
Message-ID: <54201048.9080508@xunil.at>
Date: Mon, 22 Sep 2014 14:04:24 +0200
From: "Stefan G. Weichinger" <lists@xunil.at>
Reply-To: lists@xunil.at
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Unable to mount multiple subvolumes of a single disk
References: <5417022A.5000101@codethink.co.uk> <54170BCA.7070900@fb.com> <54170F35.4040103@oracle.com> <541839E5.5030006@fb.com> <541958A2.1030204@oracle.com> <54198AD5.1080606@fb.com>
In-Reply-To: <54198AD5.1080606@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 17.09.2014 um 15:21 schrieb Chris Mason:

> No problem, the original patch looked right to me too.  We're getting
> closer to rc6, I think at this point I'll revert the original patch
> until the next merge window.  Then we can step back and nail down
> exactly what is going on.

running git-sources 3.17-rc6 now and didn't need to apply the patch.
So you fixed it already?

"btrfs fi show" also displays devices correctly again.

Thanks, Stefan

