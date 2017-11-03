Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52286 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752105AbdKCIEL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 04:04:11 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eAWxN-0001BC-1b
        for linux-btrfs@vger.kernel.org; Fri, 03 Nov 2017 09:04:01 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs seed question
Date: Fri, 3 Nov 2017 09:03:55 +0100
Message-ID: <20171103090355.6c510e51@jupiter.sol.kaishome.de>
References: <20171011204759.1848abd7@olive.ig.local>
        <ff596f2f-7232-4ee0-7967-6888236cc831@oracle.com>
        <20171012092028.1fbe79d9@olive.ig.local>
        <CAJCQCtREBoFKB6_gS2WpkRuiA4nV1Ar4pcRbDB6Gaf1t8vSkLw@mail.gmail.com>
        <20171012104438.4304e99a@olive.ig.local>
        <CAJCQCtRrCMqp3FHaCqe-ZjNLryOGvhZE3MoXMqarqO7zsK4_FQ@mail.gmail.com>
        <20171012115020.070248a7@olive.ig.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 12 Oct 2017 11:50:20 -0400
schrieb Joseph Dunn <jdunn14@gmail.com>:

> On Thu, 12 Oct 2017 16:30:36 +0100
> Chris Murphy <lists@colorremedies.com> wrote:
> 
> > On Thu, Oct 12, 2017 at 3:44 PM, Joseph Dunn <jdunn14@gmail.com>
> > wrote:  
> > > On Thu, 12 Oct 2017 15:32:24 +0100
> > > Chris Murphy <lists@colorremedies.com> wrote:
> > >    
>  [...]  
>  [...]  
>  [...]  
>  [...]  
>  [...]  
>  [...]  
>  [...]  
> > > Interesting thought.  I haven't tried working with multiple seeds
> > > but I'll see what that can do.  I will say that this approach
> > > would require more pre-planning meaning that the choice of fast
> > > files could not be made based on current access patterns to tasks
> > > at hand.  This might make sense for a core set of files, but it
> > > doesn't quite solve the whole problem.    
> > 
> > 
> > I think the use case really dictates a dynamic solution that's
> > smarter than either of the proposed ideas (mine or yours).
> > Basically you want something that recognizes slow vs fast storage,
> > and intelligently populates fast storage with frequently used files.
> > 
> > Ostensibly this is the realm of dmcache. But I can't tell you
> > whether dmcache or via LVM tools, if it's possible to set the
> > proper policy to make it work for your use case. And also I have no
> > idea how to set it up after the fact, on an already created file
> > system, rather than block devices.
> > 
> > The hot vs cold files thing, is something I thought the VFS folks
> > were looking into.
> >   
> As a consumer of the file system data I tend to see things at a file
> level rather than as blocks, but from a block level this does feel
> dmcache-ish and I'll look into it.
> 
> I did try the multiple seeds approach and correct me if I'm wrong, but
> once the files are deleted in the second seed they are no longer
> accessible in anything sprouted from that.  The fully dynamic solution
> would be nice, but I'm perfectly happy to pick the files for the ssd
> at run time, just not at file system preparation time.  In any case,
> I may fall back on inotify and overwriting file contents if I don't
> end up with a better solution using dmcache or LVM tricks.

Would "btrfs filesystem defrag" not rewrite files to local storage?

Using inotify, you could work with two queues "defrag" and "done". Add
files via inotify to the defrag queue unless it's already in one of the
queues. Then move it to the done queue while running defrag on each
files of the other queue.

You can then use the done queue as a seed for defrag queue on newly
provisioned systems.


-- 
Regards,
Kai

Replies to list-only preferred.

