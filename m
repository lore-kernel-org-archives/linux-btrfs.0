Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46322 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbaENB5v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 May 2014 21:57:51 -0400
Date: Tue, 13 May 2014 18:57:46 -0700
From: David Brown <davidb@davidb.org>
To: Bernardo Donadio <bcdonadio@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: lsetxattr error when doing send/receive
Message-ID: <20140514015746.GA8032@davidb.org>
References: <lkuapc$si7$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <lkuapc$si7$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 13, 2014 at 08:44:44PM -0300, Bernardo Donadio wrote:
>Hi!
>
>I'm trying to do a send/receive of a snapshot between two disks on 
>Fedora 20 with Linux 3.15-rc5 (and also tried with 3.14 and 3.11) and 
>SELinux disabled, and then I'm receiving the following error:
>
>[root@darwin /]# btrfs subvolume snapshot -r / @.$(date 
>+%Y-%m-%d-%H%M%S)Create a readonly snapshot of '/' in 
>'./@.2014-05-13-203532'
>[root@darwin /]# btrfs send @.2014-05-13-203532 | btrfs receive /mnt/cold/
>At subvol @.2014-05-13-203532
>At subvol @.2014-05-13-203532
>ERROR: lsetxattr bin security.selinux=system_u:object_r:bin_t:s0 
>failed. Operation not supported
>
>I'm missing something? Is this a bug?

Is selinux 'disabled' or just non-enforcing?  If it is enabled, but
even non-enforcing, it still won't allow the security attributes to be
set.

   $ selinuxenabled; echo $?

should give '1' if it is truly disabled.  I believe you have to
disable it at startup time, so if you've changed the config file, you
might need to reboot.

David
