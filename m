Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57733 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab2IYN6L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 09:58:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120925101203.GQ14582@twin.jikos.cz>
References: <1348538536-29838-1-git-send-email-zwu.kernel@gmail.com>
	<1348538536-29838-2-git-send-email-zwu.kernel@gmail.com>
	<20120925101203.GQ14582@twin.jikos.cz>
Date: Tue, 25 Sep 2012 21:58:09 +0800
Message-ID: <CAEH94LjjD-HAHD8EZwOGJ6J7hi+7mkni0p2S8rz5HEQv59MrDQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] btrfs-progs: Close file descriptor on exit
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: dave@jikos.cz, zwu.kernel@gmail.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jbacik@fusionio.com,
        linuxram@linux.vnet.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 25, 2012 at 6:12 PM, David Sterba <dave@jikos.cz> wrote:
> On Tue, Sep 25, 2012 at 10:02:15AM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   Need to close fd on exit.
>
> Strictly you don't need to, kernel will do that at exit() time.
I know, but it is not so nice.

>
> david



-- 
Regards,

Zhi Yong Wu
