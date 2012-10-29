Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49756 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab2J2W0m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 18:26:42 -0400
MIME-Version: 1.0
In-Reply-To: <20121029181040.GA3605@kroah.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
	<1351485061-12297-16-git-send-email-zwu.kernel@gmail.com>
	<20121029181040.GA3605@kroah.com>
Date: Tue, 30 Oct 2012 06:26:40 +0800
Message-ID: <CAEH94LiOSQeQcRz4cokTWKn2RBm8NxmP1Sqg2zyH6JLvU6=2vw@mail.gmail.com>
Subject: Re: [RFC v4+ hot_track 15/19] sysfs: add two hot_track proc files
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
        david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
        wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 30, 2012 at 2:10 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Oct 29, 2012 at 12:30:57PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   Add two proc files hot-kick-time and hot-update-delay
>> under the dir /proc/sys/fs/ in order to turn
>> TIME_TO_KICK and HEAT_UPDATE_DELAY into be tunable.
>
> As you say, these are proc files, not sysfs files, so please fix the
>  Subject: up here.
ah, OK, i will fix it, thanks for your pointing it out.
>
> thanks,
>
> greg k-h



-- 
Regards,

Zhi Yong Wu
