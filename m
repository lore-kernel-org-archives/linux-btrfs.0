From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [RFC][PATCH 1/2] vfs: allow /proc/pid/maps to return a custom device
Date: Fri, 7 Oct 2011 11:32:21 -0700
Message-ID: <20111007183221.GA23779@wotan.suse.de>
References: <1305328729-9995-1-git-send-email-mfasheh@suse.com> <1305328729-9995-2-git-send-email-mfasheh@suse.com> <m1tycwk6hv.fsf@fess.ebiederm.org> <20110519201826.GN17822@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110519201826.GN17822@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

Ressurecting an old thread, sorry. Here's the conversation thus far:

http://www.spinics.net/lists/linux-btrfs/msg10099.html

This is still hitting folks wishing to use btrfs on suse based systems.
Using getattr() (unconditionally I might add) is possible, but will affect
performance to a far greater degree than just allowing an optional deref of
whatever structure btrfs (and similar file systems) have to point to the
right block device. Is this really the way we would like to proceed? Chris,
maybe you can chime in here?
	--Mark

On Thu, May 19, 2011 at 01:18:26PM -0700, Mark Fasheh wrote:
> On Sat, May 14, 2011 at 08:06:04PM -0700, Eric W. Biederman wrote:
> > Mark Fasheh <mfasheh@suse.com> writes:
> > 
> > > This patch introduces a callback in the super_operations structure,
> > > 'get_maps_dev' which is then used by procfs to query which device to return
> > > for reporting in /proc/[PID]/maps.
> > 
> > No.
> > 
> > It may make sense to call the vfs stat method.  But introducing an extra
> > vfs operations for this seems like a maintenance nightmare.
> 
> Yeah I'm not thrilled with the extra method either. My concern with using
> ->getattr is whether it's too heavy since that implies potential disk /
> network i/o.
> 	--Mark

--
Mark Fasheh
