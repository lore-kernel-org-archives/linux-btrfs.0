Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39613 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750795AbbAOFH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 00:07:56 -0500
Message-ID: <54B74AF8.2050600@cn.fujitsu.com>
Date: Thu, 15 Jan 2015 13:07:04 +0800
From: =?UTF-8?B?RmFuIENoZW5nbmlhbmcv5qiK5oiQ6YW/?=
	<fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs:btrfstune: choose to ignore error when
 setting seeding enabled
References: <1420791102-9948-1-git-send-email-fancn.fnst@cn.fujitsu.com> <20150114154831.GV3685@twin.jikos.cz>
In-Reply-To: <20150114154831.GV3685@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


在 2015年01月14日 23:48, David Sterba 写道:
> On Fri, Jan 09, 2015 at 04:11:41PM +0800, Fan Chengniang wrote:
>> Before with -S option, setting positive value on seeding-enabled btrfs
>> filesystem will cause error. So I add -i option which can ignore it.
> Why can't we use the existing --force/-f option for that?
That is a good idea. I will use -f instead of adding -i.
