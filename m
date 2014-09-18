Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:36764 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbaIRRTl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 13:19:41 -0400
Received: by mail-qa0-f45.google.com with SMTP id s7so1445670qap.4
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 10:19:41 -0700 (PDT)
Message-ID: <541B142B.80803@gmail.com>
Date: Thu, 18 Sep 2014 13:19:39 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Problem with unmountable filesystem.
References: <54184BD2.7000300@gmail.com>	<2A2CB71A-7516-43CD-94E1-BCB2198F5FC4@colorremedies.com>	<54196F42.4030101@gmail.com> <pan$529ae$2bc50fa8$5e7f68de$70f24efb@cox.net>
In-Reply-To: <pan$529ae$2bc50fa8$5e7f68de$70f24efb@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/17/2014 04:22 PM, Duncan wrote:
> Austin S Hemmelgarn posted on Wed, 17 Sep 2014 07:23:46 -0400 as
> excerpted:
> 
>> I've also discovered, when trying to use btrfs restore to copy out the
>> data to a different system, that 3.14.1 restore apparently chokes on
>> filesystem that have lzo compression turned on.  It's reporting errors
>> trying to inflate compressed files, and I know for a fact that none of
>> those files were even open, let alone being written to, when the system
>> crashed.  I don't know if this is a known bug or even if it is still the
>> case with btrfs-progs 3.16, but I figured I'd comment about it because I
>> haven't seen anything about it anywhere.
> 
> FWIW that's a known and recently patched issue.  If you're still seeing 
> issues with it with btrfs-progs 3.16, report it, but 3.14.1 almost 
> certainly wouldn't have had the fix.  (This is one related patch turned 
> up by a quick search; there may be others.)
> 
> * commit 93ebec96f2ae1d3276ebe89e2d6188f9b46692fb
> | Author: Vincent Stehlé <vincent.stehle@laposte.net>
> | Date:   Wed Jun 18 18:51:19 2014 +0200
> |
> |     btrfs-progs: restore: check lzo compress length
> |
> |     When things go wrong for lzo-compressed btrfs, feeding
> |     lzo1x_decompress_safe() with corrupt data during restore
> |     can lead to crashes. Reduce the risk by adding
> |     a check on the input length.
> |
> |     Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> |     Signed-off-by: David Sterba <dsterba@suse.cz>
> |
> |  cmds-restore.c | 6 ++++++
> |  1 file changed, 6 insertions(+)
> 
Yeah, 3.16 seems fine, I just hadn't updated my recovery environment
yet.  Ironically, I did some performance testing afterwards, and
realized that using any compression was actually slowing down my system
(my disk appears to be faster than my RAM, which is really sad, even for
a laptop).
