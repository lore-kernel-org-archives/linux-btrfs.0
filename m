Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36.italiaonline.it ([212.48.25.164]:44534 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751035AbcGGQiA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 12:38:00 -0400
Reply-To: kreijack@inwind.it
Subject: Re: 64-btrfs.rules and degraded boot
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <11fd9e5f-a0a4-ecfb-baca-dadab0d7902f@inwind.it>
Date: Thu, 7 Jul 2016 18:37:57 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-05 20:53, Chris Murphy wrote:
> I am kinda confused about this "btrfs ready $devnode" portion. Isn't
> it "btrfs device ready $devnode" if this is based on user space tools?

systemd, implemented this as internal command

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
