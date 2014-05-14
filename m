Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39929 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751056AbaENG4s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 02:56:48 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: lsetxattr error when doing send/receive
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <lkun5l$n9f$1@ger.gmane.org>
Date: Wed, 14 May 2014 00:56:47 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <DC21CC81-B1FE-4BCD-941B-820F716F2F74@colorremedies.com>
References: <lkuapc$si7$1@ger.gmane.org> <20140514015746.GA8032@davidb.org> <lkun5l$n9f$1@ger.gmane.org>
To: Bernardo Donadio <bcdonadio@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 13, 2014, at 9:16 PM, Bernardo Donadio <bcdonadio@gmail.com> wrote:

> On 05/13/2014 10:57 PM, David Brown wrote:
>> $ selinuxenabled; echo $?
> 
> It does return '1'. I know SELinux is disabled because I can't boot with it on (and I have no fucking clue why).
> 
> What exactly is the error complaining about, BTW?

How are you disabling it? I suggest enabling it. Then setting enforcing=0 so that it can maintain the proper labeling, and see if you still get the error.


> A guy at #selinux@freenode said something about btrfs not supporting the FS security extensions, but he didn't know how to elaborate more.

Oh dear, well that's wrong. There appear to be some xattrs that are not being restored on receive, there's another thread on that, but they aren't selinux labels.


Chris Murphy

