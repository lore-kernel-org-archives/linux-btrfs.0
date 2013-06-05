Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28987 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab3FECdF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Jun 2013 22:33:05 -0400
Message-ID: <51AEA3A0.4050203@cn.fujitsu.com>
Date: Wed, 05 Jun 2013 10:34:08 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] fix INT_MAX readdir hang, plus cleanups
References: <1370384280-28652-1-git-send-email-zab@redhat.com> <20130604231653.4088.91500@localhost.localdomain> <20130604232657.GE24721@lenny.home.zabbo.net>
In-Reply-To: <20130604232657.GE24721@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	tue, 4 Jun 2013 16:26:57 -0700, Zach Brown wrote:
> On Tue, Jun 04, 2013 at 07:16:53PM -0400, Chris Mason wrote:
>> Quoting Zach Brown (2013-06-04 18:17:54)
>>> Hi gang,
>>>
>>> I finally sat down to fix that readdir hang that has been in the back
>>> of my mind for a while.  I *hope* that the fix is pretty simple: just
>>> don't manufacture a fake f_pos, I *think* we can abuse f_version as an
>>> indicator that we shouldn't return entries.  Does this look reasonable?
>>
>> I like it, and it doesn't look too far away from how others are abusing
>> f_version.  Have you tried with NFS?  I don't think it'll hurt, but NFS
>> loves to surprise me.
> 
> Mm, no, I hadn't.  I'll give it a go tomorrow.  What could go wrong? :)

If we can not use f_version, we can use private_data. I think this variant is
safe.

Miao

> 
> - z
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

