Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52119 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbaENDQT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 May 2014 23:16:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WkPg1-0001oX-Rh
	for linux-btrfs@vger.kernel.org; Wed, 14 May 2014 05:16:17 +0200
Received: from 187.113.203.79 ([187.113.203.79])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 May 2014 05:16:17 +0200
Received: from bcdonadio by 187.113.203.79 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 May 2014 05:16:17 +0200
To: linux-btrfs@vger.kernel.org
From: Bernardo Donadio <bcdonadio@gmail.com>
Subject: Re: lsetxattr error when doing send/receive
Date: Wed, 14 May 2014 00:16:04 -0300
Message-ID: <lkun5l$n9f$1@ger.gmane.org>
References: <lkuapc$si7$1@ger.gmane.org> <20140514015746.GA8032@davidb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <20140514015746.GA8032@davidb.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/13/2014 10:57 PM, David Brown wrote:
> $ selinuxenabled; echo $?

It does return '1'. I know SELinux is disabled because I can't boot with 
it on (and I have no fucking clue why).

What exactly is the error complaining about, BTW? A guy at 
#selinux@freenode said something about btrfs not supporting the FS 
security extensions, but he didn't know how to elaborate more.

Thanks.

--
Bernardo Donadio

