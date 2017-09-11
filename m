Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2.lkj.it ([188.213.165.207]:38712 "EHLO smtp2.lkj.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750742AbdIKHJP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 03:09:15 -0400
Received: from mail.editarea.com (unknown [172.20.2.194])
        by smtp2.lkj.it (Postfix) with ESMTPS id 4C23A64858
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 09:01:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.editarea.com (Postfix) with ESMTP id 61213418CA49
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 09:01:17 +0200 (CEST)
Received: from mail.editarea.com ([127.0.0.1])
        by localhost (mail.editarea.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id exRBZhXwxuwS for <linux-btrfs@vger.kernel.org>;
        Mon, 11 Sep 2017 09:01:16 +0200 (CEST)
Received: from [192.168.1.101] (93-38-67-59.ip69.fastwebnet.it [93.38.67.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.editarea.com (Postfix) with ESMTPSA id 6E12A41846F7
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 09:01:15 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: Alessandro Polverini <alex@polverini.org>
Subject: btrfs send fails with ioctl error 524
Message-ID: <6be3c5f6-b33e-cf5d-af76-7c07b688a554@polverini.org>
Date: Mon, 11 Sep 2017 09:01:14 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I've opened a bug report here:

https://bugzilla.kernel.org/show_bug.cgi?id=196903

because I'm unable to transfer snapshots any more, I get the error:

 > ERROR: send ioctl failed with -524: Unknown error 524

I don't know how to solve the problem, I'm stuck.

Any help would be very welcome!

Alex

P.S.: I'm not subscribed to the list, please CC me
