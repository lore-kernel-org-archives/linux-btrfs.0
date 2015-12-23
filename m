Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10078 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751691AbbLWFKI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 00:10:08 -0500
Subject: Re: [PATCH v4 1/2] btrfs: Introduce new mount option backuproot to
 replace recovery
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <1450750596-14627-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1450820151.5520.33.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <567A2C9E.7060806@cn.fujitsu.com>
Date: Wed, 23 Dec 2015 13:09:50 +0800
MIME-Version: 1.0
In-Reply-To: <1450820151.5520.33.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Christoph Anton Mitterer wrote on 2015/12/22 22:35 +0100:
> On Tue, 2015-12-22 at 10:16 +0800, Qu Wenruo wrote:
>> Current "recovery" mount option will only try to use backup root.
>> However the word "recovery" is too generic and may be confusing for
>> some
>> users.
> I would rather call it something like "restorebackuproot" or
> "usebackuproot",... caues "backuproot" sounds more like *doing* the
> action "backup root".

Make sense.

I'll pick "usebackuproot" for next version.

Thanks,
Qu

>
> Cheers,
> Chris.
>


