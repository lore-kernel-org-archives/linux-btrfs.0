Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34.italiaonline.it ([212.48.25.162]:39269 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S944490AbdEZShf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 14:37:35 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH v4 00/20] Btrfs-progs offline scrub
References: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, lakshmipathi.g@gmail.com
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <e4e15f16-c6b7-a18a-57df-7f404d38107b@inwind.it>
Date: Fri, 26 May 2017 20:37:30 +0200
MIME-Version: 1.0
In-Reply-To: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

On 2017-05-25 08:21, Qu Wenruo wrote:

> And since kernel scrub won't account P/Q corruption, it makes us quite
> hard to detect error like kernel screwing up P/Q when scrubbing.

could you elaborate the above sentence: in my test the kernel-scrub (4.12.0-rc2) is able to correct a wrong 'P' parity; am I missing something ?

BR
G.Baroncelli
[...]

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
