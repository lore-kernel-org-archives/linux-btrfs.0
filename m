Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:50583 "EHLO
	homiemail-a51.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754602Ab3GVDhi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Jul 2013 23:37:38 -0400
From: Shridhar Daithankar <ghodechhap@ghodechhap.net>
To: george@chinilu.com
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: autodefrag by default, was: Lots of harddrive chatter
Date: Mon, 22 Jul 2013 09:07:35 +0530
Message-ID: <5436903.bmHYcuMpfJ@bheem>
In-Reply-To: <51EC7249.3010005@chinilu.com>
References: <ksf42h$suu$1@ger.gmane.org> <pan$7e18b$b2c36a61$b1f22c8c$6c61ba6e@cox.net> <51EC7249.3010005@chinilu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday, July 21, 2013 04:44:09 PM George Mitchell wrote:
> Unless auto-defrag can work around the 
> in-use file issue, that could be a problem since some heavily used 
> system files are open virtually all the time the system is up and 
> running.  Has this issue been investigated and if so are there any 
> system files that don't get defragmented that matter?  Or is this a 
> non-issue in that any constantly in use system files don't really matter 
> anyway?  That is really the only question I have before moving away from 
> my current offline approach to the auto-defrag mount option for system 
> filesystems (/, /boot, /usr, /opt, /var, etc).

AFAIK, defragmentation is proportional to amount of writes to a file or 
direcotries.

system files typically are installed once and never rewritten in place, so 
they should not be much fragmented to begin with.

now their directory objects, is a different story and so is things like 
systemd journal, log files, or database files. 
-- 
Regards
 Shridhar
