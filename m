Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob10.myregisteredsite.com ([209.17.115.48]:40024 "EHLO
	atl4mhob10.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755300Ab3GVDxj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Jul 2013 23:53:39 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.117])
	by atl4mhob10.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r6M3rbXB009242
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Jul 2013 23:53:37 -0400
Message-ID: <51ECACC6.1090104@chinilu.com>
Date: Sun, 21 Jul 2013 20:53:42 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Shridhar Daithankar <ghodechhap@ghodechhap.net>
CC: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: autodefrag by default, was: Lots of harddrive chatter
References: <ksf42h$suu$1@ger.gmane.org> <pan$7e18b$b2c36a61$b1f22c8c$6c61ba6e@cox.net> <51EC7249.3010005@chinilu.com> <5436903.bmHYcuMpfJ@bheem>
In-Reply-To: <5436903.bmHYcuMpfJ@bheem>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/21/2013 08:37 PM, Shridhar Daithankar wrote:
> On Sunday, July 21, 2013 04:44:09 PM George Mitchell wrote:
>> Unless auto-defrag can work around the
>> in-use file issue, that could be a problem since some heavily used
>> system files are open virtually all the time the system is up and
>> running.  Has this issue been investigated and if so are there any
>> system files that don't get defragmented that matter?  Or is this a
>> non-issue in that any constantly in use system files don't really matter
>> anyway?  That is really the only question I have before moving away from
>> my current offline approach to the auto-defrag mount option for system
>> filesystems (/, /boot, /usr, /opt, /var, etc).
> AFAIK, defragmentation is proportional to amount of writes to a file or
> direcotries.
>
> system files typically are installed once and never rewritten in place, so
> they should not be much fragmented to begin with.
>
> now their directory objects, is a different story and so is things like
> systemd journal, log files, or database files.
Never rewritten in place?  I wouldn't go that far.  In the case of many 
distros there is a continual flow of updates which results in some 
degree of data churning throughout the system filesystems. Just a kernel 
update, for example, can affect a rather large number of files and 
directories with new writes while application updates (KDE or even Gnome 
for example) can cause a large number of files to be rewritten in place.
