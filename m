Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10643 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750835AbbBKAdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 19:33:07 -0500
Message-ID: <54DAA33F.7040109@cn.fujitsu.com>
Date: Wed, 11 Feb 2015 08:33:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 00/10] Enhance btrfs-find-root and open_ctree() to
 provide better chance on damaged btrfs.
References: <1422522437-18886-1-git-send-email-quwenruo@cn.fujitsu.com> <20150210144839.GC28877@twin.jikos.cz>
In-Reply-To: <20150210144839.GC28877@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH v3 00/10] Enhance btrfs-find-root and open_ctree() 
to provide better chance on damaged btrfs.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年02月10日 22:48
> On Thu, Jan 29, 2015 at 05:07:15PM +0800, Qu Wenruo wrote:
>> Also, since only 2 patches is modified(although other part is slightly
>> modified to match the change), to avoid mail bombing, I created the pull
>> request on github and only send the first 2 patches with cover-letter.
>> https://github.com/kdave/btrfs-progs/pull/5
> Sending the changed patches only is ok (if you point me at the rest of
> the patches), but it's not necessary to open the github pull request.
>
> The version to version changelogs are also stored in the commit
> changelogs, that's a bit unexpected for a branch to be pulled.
Oh, very sorry for this.
I was meant to save your time, but I forgot that pull branch won't emit 
the changelog like patches.

I'll take care next time.

Thanks,
Qu
>
> I've been reviewing this patch series and am mostly ok with that so I'm
> going to pull that soon.
>

