From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC][PATCH 1/2] vfs: allow /proc/pid/maps to return a custom device
Date: Sat, 14 May 2011 20:06:04 -0700
Message-ID: <m1tycwk6hv.fsf@fess.ebiederm.org>
References: <1305328729-9995-1-git-send-email-mfasheh@suse.com>
	<1305328729-9995-2-git-send-email-mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Mark Fasheh <mfasheh@suse.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1305328729-9995-2-git-send-email-mfasheh@suse.com> (Mark
	Fasheh's message of "Fri, 13 May 2011 16:18:48 -0700")
List-ID: <linux-btrfs.vger.kernel.org>

Mark Fasheh <mfasheh@suse.com> writes:

> This patch introduces a callback in the super_operations structure,
> 'get_maps_dev' which is then used by procfs to query which device to return
> for reporting in /proc/[PID]/maps.

No.

It may make sense to call the vfs stat method.  But introducing an extra
vfs operations for this seems like a maintenance nightmare.


Eric
