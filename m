Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49012 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbcESBKA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 21:10:00 -0400
Subject: Re: [PATCH] btrfs: switch to common message helpers in open_ctree,
 adjust messages
To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1462786798-15247-1-git-send-email-dsterba@suse.com>
 <573148AB.6080800@oracle.com> <20160510074203.GP29353@twin.jikos.cz>
 <57319541.7000300@oracle.com> <20160510082120.GQ29353@twin.jikos.cz>
 <57319E9A.8070003@oracle.com> <20160510142856.GV29353@twin.jikos.cz>
 <5731F771.2060509@oracle.com> <20160511105619.GZ29353@twin.jikos.cz>
 <57331DCD.2090600@oracle.com> <20160517124218.GK511@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <573D122F.80305@oracle.com>
Date: Thu, 19 May 2016 09:09:03 +0800
MIME-Version: 1.0
In-Reply-To: <20160517124218.GK511@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



 > You mean a shorter UUID? The first four bytes (8 hexa digits) seem
 > unique enough. That can be optinal I think.

  Yes. I said that.
  But I am also thinking FSID is user changeable (which is good),
  and so it should be easy to show that this method fails.

>>> Another way came to my mind: make it a module parameter, so
>>> even the mount option or sysfs settings is not needed and the defaults
>>> are system-wide.

> I'm fine with adding the configurable logging
> options.

  This should be fine, I can't think of anything better.


Thanks, Anand
