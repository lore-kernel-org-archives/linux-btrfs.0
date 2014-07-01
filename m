Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:55413 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753219AbaGADLd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jun 2014 23:11:33 -0400
Date: Mon, 30 Jun 2014 21:06:24 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: linux-btrfs@vger.kernel.org
Subject: Re: Blocked tasks on 3.15.1
Message-ID: <20140701030624.GA28524@pyropus.ca>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
 <4623589E-3298-4980-A257-665CFA9FB61B@colorremedies.com>
 <pan$26aa0$13a0ca68$c41d00a9$e8c14640@cox.net>
 <3081460.dX0cLeJPhK@quad>
 <CAPoQQ-093rEw6mRRDCS4bq8oGOvmuR_a6UAVOjK_ytb=Yq2BSw@mail.gmail.com>
 <53B1A862.50503@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53B1A862.50503@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <clm@fb.com> wrote:
> On 06/29/2014 04:02 PM, Cody P Schafer wrote:
> >> been able to resurrect it yet.
> > 
> > I'm also seeing stuck tasks on btrfs (3.14.4, 3.15.1, 3.15.2).

I'm seeing these with 3.15.2 as well.

> Could you please send a sysrq-t and sysrq-l while you're stuck?  That
> will show us all the procs and all the CPUs.

For what it's worth, http://bpaste.net/show/BswHMVpHlguSrdELgv7e/ is my syslog
covering my most recent "stuck" event, including the results of sysrq-t and
sysrq-l.

Charles
-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------
