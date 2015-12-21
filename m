Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21740 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbbLUFTS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 00:19:18 -0500
Subject: Re: Ideas to do custom operation just after mount?
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <56721602.5050204@cn.fujitsu.com> <20151221001654.GM19802@dastard>
 <56776330.1090500@cn.fujitsu.com> <5677662F.2060806@cn.fujitsu.com>
Cc: Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
        btrfs <linux-btrfs@vger.kernel.org>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56778B9E.8050900@oracle.com>
Date: Mon, 21 Dec 2015 13:18:22 +0800
MIME-Version: 1.0
In-Reply-To: <5677662F.2060806@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> BTW, any good idea for btrfs to do such operation like
> enabling/disabling some minor features? Especially when it can be set on
> individual file/dirs.
>
> Features like incoming write time deduplication, is designed to be
> enabled/disabled for individual file/dirs, so it's not a quite good idea
> to use mount option to do it.
>
> Although some feature, like btrfs quota(qgroup), should be implemented
> by mount option though.
> I don't understand why qgroup is enabled/disabled by ioctl. :(


mount option won't persist across systems/computers unless remembered by 
human.


Thanks, Anand
