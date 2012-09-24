Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:33138 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab2IXOEA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 10:04:00 -0400
Date: Mon, 24 Sep 2012 16:03:42 +0200
From: David Sterba <dave@jikos.cz>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: chris.mason@fusionio.com, yongjun_wei@trendmicro.com.cn,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix return value check in btrfs_ioctl_send()
Message-ID: <20120924140342.GG14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAPgLHd8z-dQPB=vGe2wH+5mw0sUkr4-RrihtWx2bnzTc5y3Vjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPgLHd8z-dQPB=vGe2wH+5mw0sUkr4-RrihtWx2bnzTc5y3Vjw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 09:40:00PM +0800, Wei Yongjun wrote:
> >> dpatch engine is used to auto generated this patch.
> >> (https://github.com/weiyj/dpatch)
> > I've played with it, looks nice, although it's full of hardcoded paths.
> 
> Yes, it is current hardcoded path, because I used the linux.git and
> linux-next.git, and dpatch will update the git tree every day.
> After login, you can change the git url in the web.

Sure, I was able to point the git source to my local linux.git.

> > I'd like to run it directly from the git repo. Can you please fix that?
> > No patch from me, because I hadcoded my paths :)
> 
> Do you mean does not need auto update git repo, only scan the
> change under your git repo?

I'm talking about hardcoded paths for the scripts in bin/ like

dpatch/views/engine.py:
args = '/usr/dpatch/bin/importcocci.sh %s' % fname

or dpatch/models.py:
return '/var/lib/dpatch/repo/' + dname

Not to say that '/usr/' is not the right place for adding new
per-package subdirs, refer to
http://www.pathname.com/fhs/pub/fhs-2.3.html#THEUSRHIERARCHY
.

(Also the database has hardcoded path into /var/lib/dpatch)

> > It would be great if we can run a set of .cocci scripts that would
> > verify code invariants (limited to cocci capabilities, but eg. the
> > IS_ERR is a good example) and add new ones eventually over time.
> 
> By default, It does not include cocci scripts, only include dup include,
> useless 'linux/version.h' check engine, and is disabled.

No problem that the .cocci scripts are not there, I'm fine with adding
them manually now, just to test the tool, but all the hardcoded paths
didn't let me do that :)

david
