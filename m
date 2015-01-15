Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbbAOMaF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 07:30:05 -0500
Date: Thu, 15 Jan 2015 13:30:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Fan =?utf-8?B?Q2hlbmduaWFuZy/mqIrmiJDphb8=?=
	<fancn.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] btrfs-progs: make btrfs qgroups show human
 readable sizes
Message-ID: <20150115123003.GE3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421128419-17169-1-git-send-email-fancn.fnst@cn.fujitsu.com>
 <20150114154633.GU3685@twin.jikos.cz>
 <54B7150D.20903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <54B7150D.20903@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 15, 2015 at 09:17:01AM +0800, Fan Chengniang/樊成酿 wrote:
> 
> 在 2015年01月14日 23:46, David Sterba 写道:
> > On Tue, Jan 13, 2015 at 01:53:39PM +0800, Fan Chengniang wrote:
> >> make btrfs qgroups show human readable sizes
> >> using --human-readable option, example:
> > That's too long to type and the idea was to add all the long options
> > that force the specific unit base, ie. --kbytes/--mbytes/..., --raw,
> > --si and --iec. We can possibly make the human readable the default
> > because that's what I'd expect to see to have a quick overview and can
> > use the other options otherwise.
> >
> > The geopt parser accepts short options if they're unique, so --kb or
> > even --k works as a very convenient shorcut for frequent commandline
> > use.
> I have sent a mail for your advise of adding options. In that mail, I 
> asked whether I should use --human-readable and add --kbytes --mbytes ...
> But you have not reply to me.

So you've sent a v2 where we can see if our ideas match or not and
continue from there. Timely replies are not always feasible, I get a lot
of mails. Patch iterations are normal, nothing new here.

> So, your advise is add --kbytes --mbytes ... and make human-readable 
> default behaviour?
> >> qgroupid rfer         excl         max_rfer     max_excl     parent  child
> >> -------- ----         ----         --------     --------     ------  -----
> >> 0/5      299.58MiB    299.58MiB    400.00MiB    0.00B        1/1     ---
> >> 0/265    299.58MiB    16.00KiB     0.00B        320.00MiB    1/1     ---
> >> 0/266    299.58MiB    16.00KiB     350.00MiB    0.00B        ---     ---
> >> 1/1      599.16MiB    299.59MiB    800.00MiB    0.00B        ---     0/5,0/265
> > The values should be also aligned to the right.
> It is aligned to left before my patch. I just keep it.

Ok, take it as a hint for another patch.
