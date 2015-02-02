Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:43845 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbbBBFIN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Feb 2015 00:08:13 -0500
MIME-Version: 1.0
In-Reply-To: <20150202100338.4fa9eefa@notabene.brown>
References: <20141028142541.GA19097@wfg-t540p.sh.intel.com>
	<20150201034315.GA20124@wfg-t540p.sh.intel.com>
	<20150202100338.4fa9eefa@notabene.brown>
Date: Sun, 1 Feb 2015 21:08:12 -0800
Message-ID: <CA+55aFyR-ZK9Y2KkxbcTnMOcCc243ZKD6AKTuktpmyE0HCUcPw@mail.gmail.com>
Subject: Re: __might_sleep() warnings on v3.19-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, LKP <lkp@01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 1, 2015 at 3:03 PM, NeilBrown <neilb@suse.de> wrote:
>
> I guess I could
>       __set_current_state(TASK_RUNNING);
> somewhere to defeat the warning, and add a comment explaining why.
>
> Would that be a good thing?

Use "sched_annotate_sleep()" instead, but yes, add a comment about why it's ok.

                        Linus
