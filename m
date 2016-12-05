Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36684 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbcLEFvH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 00:51:07 -0500
Received: by mail-pf0-f193.google.com with SMTP id c4so16465338pfb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Dec 2016 21:51:06 -0800 (PST)
Received: from [172.27.27.99] (122-59-45-101.jetstream.xtra.co.nz. [122.59.45.101])
        by smtp.gmail.com with ESMTPSA id f132sm23820156pfa.72.2016.12.04.21.51.03
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Dec 2016 21:51:04 -0800 (PST)
Subject: Re: btrfs repair and zero-log doesn't seem to do anything
To: linux-btrfs@vger.kernel.org
References: <6dbdc042-6b05-8270-e869-fcf95a99157d@gmail.com>
 <a3bad432-968b-83e8-4c35-69e27124107e@cn.fujitsu.com>
From: Calle Kabo <calle.kabo@gmail.com>
Message-ID: <24c80d7e-e2d9-0b93-2ded-96ddcb741070@gmail.com>
Date: Mon, 5 Dec 2016 18:50:59 +1300
MIME-Version: 1.0
In-Reply-To: <a3bad432-968b-83e8-4c35-69e27124107e@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> Maybe -D would list all the file structures?

I tried that first but didn't see anything, but when combined with -v it
shows the files that would have been restored.

e.g.
# btrfs restore -v -D --path-regex '^/(|Documents(|/.*))$'
/dev/mapper/data-0 /tmp


Awesome, big thanks for your help!

/Calle
