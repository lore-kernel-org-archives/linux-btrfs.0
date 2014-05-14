Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58737 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752156AbaENOl6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 10:41:58 -0400
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id B1F86210AD
	for <linux-btrfs@vger.kernel.org>; Wed, 14 May 2014 10:41:57 -0400 (EDT)
Date: Wed, 14 May 2014 07:41:54 -0700
From: David Brown <davidb@davidb.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Bernardo Donadio <bcdonadio@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: lsetxattr error when doing send/receive
Message-ID: <20140514144154.GA9110@davidb.org>
References: <lkuapc$si7$1@ger.gmane.org>
 <20140514015746.GA8032@davidb.org>
 <5B4A1BF5-7178-448B-8989-50B793C0912D@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <5B4A1BF5-7178-448B-8989-50B793C0912D@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 14, 2014 at 12:52:50AM -0600, Chris Murphy wrote:
>
>On May 13, 2014, at 7:57 PM, David Brown <davidb@davidb.org> wrote:
>
>> On Tue, May 13, 2014 at 08:44:44PM -0300, Bernardo Donadio wrote:
>>> Hi!
>>>
>>> I'm trying to do a send/receive of a snapshot between two disks on Fedora 20 with Linux 3.15-rc5 (and also tried with 3.14 and 3.11) and SELinux disabled, and then I'm receiving the following error:
>>>
>>> [root@darwin /]# btrfs subvolume snapshot -r / @.$(date +%Y-%m-%d-%H%M%S)Create a readonly snapshot of '/' in './@.2014-05-13-203532'
>>> [root@darwin /]# btrfs send @.2014-05-13-203532 | btrfs receive /mnt/cold/
>>> At subvol @.2014-05-13-203532
>>> At subvol @.2014-05-13-203532
>>> ERROR: lsetxattr bin security.selinux=system_u:object_r:bin_t:s0 failed. Operation not supported
>>>
>>> I'm missing something? Is this a bug?
>>
>> Is selinux 'disabled' or just non-enforcing?  If it is enabled, but
>> even non-enforcing, it still won't allow the security attributes to be
>> set.
>
>Reverse that. If selinux is disabled, labels can't be set. If not
>enforcing, you won't get AVC denials for the vast majority of events,
>but labels can be set and e.g. restorecon will still work.

   $ selinuxenabled ; echo $?
   0
   $ touch /var/tmp/foo
   $ sudo setfattr -n security.selinux -v system_u:object_r:bin_t:s0 /var/tmp/foo
   $ ls -lZ /var/tmp/foo
   -rw-rw-r--. davidb davidb system_u:object_r:bin_t:s0      /var/tmp/foo

and on a machine with selinux disabled:

   $ selinuxenabled ; echo $?
   1
   $ touch /var/tmp/foo
   $ sudo setfattr -n security.selinux -v system_u:object_r:bin_t:s0 /var/tmp/foo
   $ ls -lZ /var/tmp/foo
   -rw-rw-r--. davidb davidb system_u:object_r:bin_t:s0      /var/tmp/foo

so it doesn't actually seem to matter.  At this point, I'm suspecting
this was actually a bug in a kernel I was running at some point, and I
just haven't bothered trying to enable selinux since then.  I
definitely have received errors in the past from rsync that look like
the above error that I could fix by booting with selinux disabled.

David
