Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27046 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161860AbcEaAjD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 20:39:03 -0400
Subject: Re: [PATCH] btrfs-progs: tests: run rollback after conversion
To: <dsterba@suse.cz>, David Sterba <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>
References: <1464623554-5119-1-git-send-email-dsterba@suse.com>
 <20160530155656.GD29147@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <d9f97248-c57c-81f6-2eae-00fe989ab4b8@cn.fujitsu.com>
Date: Tue, 31 May 2016 08:38:57 +0800
MIME-Version: 1.0
In-Reply-To: <20160530155656.GD29147@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the report.

We will check it and fix it soon.

Thanks,
Qu

David Sterba wrote on 2016/05/30 17:56 +0200:
> Hi Qu,
>
> the convert patchset does not pass a rollback test, fails in the case of
> 32k nodesize. Thre's not much info why, just 'rollback failed'.
>
> The branch that passes is 'test-rollback', it's current devel without
> the convert and low-mem fsck patchsets.
>
>


