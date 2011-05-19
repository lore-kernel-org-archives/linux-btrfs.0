From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: [RFC][PATCH 1/2] vfs: allow /proc/pid/maps to return a custom device
Date: Thu, 19 May 2011 13:18:26 -0700
Message-ID: <20110519201826.GN17822@wotan.suse.de>
References: <1305328729-9995-1-git-send-email-mfasheh@suse.com> <1305328729-9995-2-git-send-email-mfasheh@suse.com> <m1tycwk6hv.fsf@fess.ebiederm.org>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m1tycwk6hv.fsf@fess.ebiederm.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 14, 2011 at 08:06:04PM -0700, Eric W. Biederman wrote:
> Mark Fasheh <mfasheh@suse.com> writes:
> 
> > This patch introduces a callback in the super_operations structure,
> > 'get_maps_dev' which is then used by procfs to query which device to return
> > for reporting in /proc/[PID]/maps.
> 
> No.
> 
> It may make sense to call the vfs stat method.  But introducing an extra
> vfs operations for this seems like a maintenance nightmare.

Yeah I'm not thrilled with the extra method either. My concern with using
->getattr is whether it's too heavy since that implies potential disk /
network i/o.
	--Mark

--
Mark Fasheh
