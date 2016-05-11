Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbcEKK4m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 06:56:42 -0400
Date: Wed, 11 May 2016 12:56:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: switch to common message helpers in open_ctree,
 adjust messages
Message-ID: <20160511105619.GZ29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462786798-15247-1-git-send-email-dsterba@suse.com>
 <573148AB.6080800@oracle.com>
 <20160510074203.GP29353@twin.jikos.cz>
 <57319541.7000300@oracle.com>
 <20160510082120.GQ29353@twin.jikos.cz>
 <57319E9A.8070003@oracle.com>
 <20160510142856.GV29353@twin.jikos.cz>
 <5731F771.2060509@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5731F771.2060509@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 10, 2016 at 11:00:01PM +0800, Anand Jain wrote:
> >>    If there is something that works simple, better. I am fine.
> >>
> >>    Generally servers may have more than one fs mounted. So filter
> >>    by fsid comes handy. Without worrying about when it was labeled,
> >>    and troubleshooting scripts to fail.
> >
> > The idea is:
> >
> >    mount -o log=fsid /dev/sda /mnt/path
> 
> 
>   This makes life of a 3rd party troubleshooter more difficult. As it
>   needs to be understood what mount option was used, and if its not
>   changed in between by the customer, and if the logs by filter won't
>   show some of the critical logs, would lead to a wrong analysis of
>   the issue.
> 
>   But whats the concern for print FSID by default (without having to
>   come through the -o log=fsid) ?

Concerns as I see them:

* current default is to print the device name -- so this would mean a
  forced change in defaults
* the FSID is not very human friendly. I can remember several device
  names and I'll probably know which filesystem is on which
* the FSID is very long, consumes half of the line before the actual
  message starts

I understand the benefits of automated filtering by FSID, but we have
conflicting interests here. If you're going to deploy automated log
scanning, you probably have automated the filesystem mkfs & mount, so
it's a matter of configuration to get it done and in one place.

>   Just my understanding:
>   For real end users we need to provide everything at the cli output.
>   That is without asking them to refer to dmesg in the cli out put. IMO.
>   (I could be wrong). Troubleshooters are the people looking at dmesg.
>   So finding the FSID can be expected ?

I don't think that looking up device names is making troubleshooting
significantly harder and never found it to be a problem in my past
experienes.

Besides, errors from lower layers report the device names, so bad
sectors or failed writes pop up very quickly in the searches.

Either way, I'm willing to make it configurable so it addresses all
usecases. Another way came to my mind: make it a module parameter, so
even the mount option or sysfs settings is not needed and the defaults
are system-wide.

>   Further there is nothing avoids user not to label two FS with the
>   same label.

That's true and users' responsibility not to shoot themselves.
