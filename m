Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbbAOMCF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 07:02:05 -0500
Date: Thu, 15 Jan 2015 13:02:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Roman Mamedov <rm@romanrm.net>
Cc: dsterba@suse.cz, Fan Chengniang <fancn.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] btrfs-progs: make btrfs qgroups show human
 readable sizes
Message-ID: <20150115120202.GC3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421128419-17169-1-git-send-email-fancn.fnst@cn.fujitsu.com>
 <20150114154633.GU3685@twin.jikos.cz>
 <20150114232029.04bb3bec@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150114232029.04bb3bec@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 14, 2015 at 11:20:29PM +0500, Roman Mamedov wrote:
> On Wed, 14 Jan 2015 16:46:33 +0100
> David Sterba <dsterba@suse.cz> wrote:
> 
> > On Tue, Jan 13, 2015 at 01:53:39PM +0800, Fan Chengniang wrote:
> > > make btrfs qgroups show human readable sizes
> > > using --human-readable option, example:
> > 
> > That's too long to type and the idea was to add all the long options
> > that force the specific unit base, ie. --kbytes/--mbytes/..., --raw,
> > --si and --iec. We can possibly make the human readable the default
> > because that's what I'd expect to see to have a quick overview and can
> > use the other options otherwise.
> > 
> > The geopt parser accepts short options if they're unique, so --kb or
> > even --k works as a very convenient shorcut for frequent commandline
> > use.
> 
> FWIW both of the GNU coreutils "df" and "ls" use the "-h, --human-readable"
> combination of options. Also the human-readable sizes are not the default format with those.
> Why not follow the rule of the least surprise and just adopt the same behavior?

I was not aware of the existing long option, makes sense to add them as
an alias of -h/-H.

I'm not sure what to do about the default output. 'ls' prints raw bytes,
'df' prints a raw number that's in Kilobytes, without a suffix. To
follow principle of least surprise in the context of btrfs-progs is to
print the human readable by default, like 'fi df/show' has been doing.

My rationale behind the default is to give a quick overview to user, I
type 'df -h' all the time and haven't used a plain 'df' since long. The
ability to quickly recognize and comprehend numbers goes down after 5-6
digits, while the numbers + largest suffix are within that limit.
