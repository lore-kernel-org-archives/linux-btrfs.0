Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:58753 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750919AbaENGww convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 02:52:52 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: lsetxattr error when doing send/receive
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140514015746.GA8032@davidb.org>
Date: Wed, 14 May 2014 00:52:50 -0600
Cc: Bernardo Donadio <bcdonadio@gmail.com>, linux-btrfs@vger.kernel.org
Message-Id: <5B4A1BF5-7178-448B-8989-50B793C0912D@colorremedies.com>
References: <lkuapc$si7$1@ger.gmane.org> <20140514015746.GA8032@davidb.org>
To: David Brown <davidb@davidb.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 13, 2014, at 7:57 PM, David Brown <davidb@davidb.org> wrote:

> On Tue, May 13, 2014 at 08:44:44PM -0300, Bernardo Donadio wrote:
>> Hi!
>> 
>> I'm trying to do a send/receive of a snapshot between two disks on Fedora 20 with Linux 3.15-rc5 (and also tried with 3.14 and 3.11) and SELinux disabled, and then I'm receiving the following error:
>> 
>> [root@darwin /]# btrfs subvolume snapshot -r / @.$(date +%Y-%m-%d-%H%M%S)Create a readonly snapshot of '/' in './@.2014-05-13-203532'
>> [root@darwin /]# btrfs send @.2014-05-13-203532 | btrfs receive /mnt/cold/
>> At subvol @.2014-05-13-203532
>> At subvol @.2014-05-13-203532
>> ERROR: lsetxattr bin security.selinux=system_u:object_r:bin_t:s0 failed. Operation not supported
>> 
>> I'm missing something? Is this a bug?
> 
> Is selinux 'disabled' or just non-enforcing?  If it is enabled, but
> even non-enforcing, it still won't allow the security attributes to be
> set.

Reverse that. If selinux is disabled, labels can't be set. If not enforcing, you won't get AVC denials for the vast majority of events, but labels can be set and e.g. restorecon will still work.

selinux=0 kernel param is disabled.
enforcing=0 kernel param is enabled but not enforcing (for most things).

selinux=0 isn't recommended. enforcing=0 is better, and then ausearch -m AVC to find denials and report them so they get fixed.


Chris Murphy

