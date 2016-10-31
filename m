Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55519 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S945003AbcJaRbM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 13:31:12 -0400
Date: Mon, 31 Oct 2016 18:31:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] btrfs-progs: receive: Introduce option to exam
 and dump send stream
Message-ID: <20161031173109.GT12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160907002935.8539-1-quwenruo@cn.fujitsu.com>
 <20160907002935.8539-3-quwenruo@cn.fujitsu.com>
 <20160908094228.GK16983@twin.jikos.cz>
 <20160908095613.GL16983@twin.jikos.cz>
 <9e6d85ed-e9b7-0a7c-44d0-83f66f369692@cn.fujitsu.com>
 <20161018120749.GO11398@suse.cz>
 <ead991f8-710e-e865-7cdd-2a4390fec3dd@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ead991f8-710e-e865-7cdd-2a4390fec3dd@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 19, 2016 at 09:18:09AM +0800, Qu Wenruo wrote:
> At 10/18/2016 08:07 PM, David Sterba wrote:
> > On Thu, Oct 13, 2016 at 03:32:53PM +0800, Qu Wenruo wrote:
> >> Hi David,
> >>
> >> Any updates?
> >>
> >> If you're busy on these fix, I could fix these problem and send a new
> >> version.
> >
> > I was about to add the series to merge but the output format needs work.
> > At minimum, something that's parseable, so some commonly used format
> > (yaml or json). The current way is ok for quick overview, but I'd really
> > like to see more options of the output. The malloc/free problems are
> > minor.
> 
> Thanks for the comment.
> 
> It makes sense. And it can be the first step to make all btrfs commands 
> output parseable.
> 
> I could try to use json-c as our json library to add json output mode 
> for send dump.
> 
> Meanwhile the original design for send-dump is only for human, and the 
> json output support will be a huge work(not only for send-dump, but 
> quite a lot of other sub-commands).
> 
> What about merge send dump first, and then add json support step-by-step?

Ok, so let's do it in another way.

The output format:
* one line per stream operation
* use key=value for all operation data
* file paths are unquoted, but escaped (same what seq_escape(" \t\n\\") does)
* two options where to put the filename, first or last, let's keep it
  first for now, we can move it later on,
  for multiple paths per operation, one of them will be just anoter
  key=value with descriptive key name

Code changes:
* fold my two patches from branch dev/send-dump-wip
* the common block at the beginniing of each callback can be factored
  into a macro (ie. full_path, ret, and path_cat with the name of the
  operation)

We'll also need some stream samples that trigger all operations so we
can tune the output.
