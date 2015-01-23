Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30035 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752235AbbAWBHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Jan 2015 20:07:09 -0500
Message-ID: <54C19E85.3080502@cn.fujitsu.com>
Date: Fri, 23 Jan 2015 09:06:13 +0800
From: =?UTF-8?B?RmFuIENoZW5nbmlhbmcv5qiK5oiQ6YW/?=
	<fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4] btrfs-progs: make btrfs qgroups show human readable
 sizes
References: <1421914303-32650-1-git-send-email-fancn.fnst@cn.fujitsu.com> <20150122162409.GK13289@twin.jikos.cz>
In-Reply-To: <20150122162409.GK13289@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


在 2015年01月23日 00:24, David Sterba 写道:
> On Thu, Jan 22, 2015 at 04:11:43PM +0800, Fan Chengniang wrote:
>> v3:
>> - remove --human-readable option
>> - add --raw, --si, --iec, --kbytes, --mbytes, --gbytes, --tbytes options
>> - by default, sizes are shown in human readable format
>> - make columns which show sizes align to right. Others aligned to left.
>> v4:
>> - change default output be raw, instead of human readable.Because xfstest
>> result depend on the raw output.
> I've merged v3, that's what we want to present to the user. I'll send a
> patch to fstests to force the raw bytes output.
there is a bug in v3 which will cause the output format unaligned.
I found it and fix it in v4.
I will send it to you.
