Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40393 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760670Ab2FHIiy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jun 2012 04:38:54 -0400
Received: by eeit10 with SMTP id t10so898177eei.19
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jun 2012 01:38:53 -0700 (PDT)
Message-ID: <4FD1BA19.9030908@gmail.com>
Date: Fri, 08 Jun 2012 11:38:49 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: Tomasz Torcz <tomek@pipebreaker.pl>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs filesystems can only be mounted after an unclean shutdown
 if btrfsck is run and immediately killed!
References: <4FD1B72D.3010002@gmail.com> <20120608082839.GA2918@mother.jarsat.pl>
In-Reply-To: <20120608082839.GA2918@mother.jarsat.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Παρασκευή, 8 Ιούνιος 2012 11:28:39 πμ, Tomasz Torcz wrote:
> On Fri, Jun 08, 2012 at 11:26:21AM +0300, Konstantinos Skarlatos wrote:
>> Hi all,
>> I have two multi-disk btrfs filesystems on a Arch linux 3.4.0
>> system. After a power failure, both filesystems refuse to mount
>
>    Multi-device filesystem had to be first fully discovered by
> "btrfs device scan".  It is typically done from udev rules. Also,
> dracut does it in initramfs for quite a long time.
>
(Added cc to btrfs list)

You are right, i have forgotten to enable it (arch linux has a new 
rc.conf option for that), i will reboot in a few minutes to test it.
Maybe it would be prudent to give a better error message when such a 
thing happens, or even make mount run btrfs device scan if it detects 
that a multi-drive fs is being mounted?
